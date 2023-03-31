#===============================================#
#                                               #
#     Analysis Ic: RCT vs RWE with LAC cum      #
#                                               #
#===============================================#
# 
# ipcw.grp = proj.grp = year.grp
# max.year=5
source("cv_glmnet_rep.R")

ate.ehr.phecode.by.year = function(surv,trt,
                                      Z.main, Z.inter, Z.inter.1, 
                                      Z.time, Z.inter.time, Z.inter.1.time, 
                           ipcw.grp, proj.grp, 
                           surv.rct, trt.rct, Z.rct, #Z.match, 
                           max.year=5, 
                           cv.rep = 100, 
                           or.pen.off, or.lambda.off, or.lambda,
                           ps.pen.old.off,  ps.lambda.old.off, ps.lambda.old,
                           ps.pen.off,  ps.lambda.off, ps.lambda,
                           pos.exclude, 
                           dr.pen, dr.lambda 
)
{
  
  # RCT
  #==========================================
  m1.rct = do.call(data.frame, 
                   summary(survfit(surv.rct~1, subset = trt.rct==1))[c("time","surv")])
  m0.rct = do.call(data.frame, 
                   summary(survfit(surv.rct~1, subset = trt.rct==0))[c("time","surv")])
  
  out = list(mu1.rct = m1.rct, mu0.rct = m0.rct)
  
  
  # EHR project to RCT
  #==========================================
  
  # Train the four models
  #-------------------------------------
  
  if(missing(pos.exclude))
  {
    # Initial PS: main effect only
    if(missing(ps.pen.old.off))
    {
      ps.ridge = cv.glmnet.rep(cv.rep, Z.main, trt, 
                           family = "binomial", 
                           alpha = 0)
      out$ps.pen.old.off = ps.pen.old.off = 1/abs(coef(ps.ridge$fit, s = ps.ridge$lambda.min)[-1])
      
    }
    if(missing(ps.lambda.old.off))
    {
        ps.ada = cv.glmnet.rep(cv.rep, Z.main, trt, 
                           family = "binomial",
                           penalty.factor = ps.pen.old.off)
        ps.coef.old.off = drop(coef(ps.ada$fit, s = ps.ada$lambda.min))
        ps.offset.old = ps.coef.old.off[1] + drop(Z.main %*% ps.coef.old.off[-1])
        out$ps.lambda.old.off = ps.lambda.old.off = ps.ada$lambda.min
      
    }else
    {

        ps.ada = glmnet(Z.main, trt,  
                        family = "binomial",
                        penalty.factor = ps.pen.old.off)
        ps.coef.old.off = drop(coef(ps.ada, s = ps.lambda.old.off))
        ps.offset.old = (ps.coef.old.off[1] + drop(Z.main %*% ps.coef.old.off[-1]))
    }
    var.sel = colnames(Z.main)[ps.coef.old.off[-1]!=0]
    if(any(grepl("^stage", var.sel)))
    {
      var.sel = c(var.sel, colnames(Z.main)[grepl("^stage", colnames(Z.main))])
    }
    if(any(grepl("^seg", var.sel)))
    {
      var.sel = c(var.sel, colnames(Z.main)[grepl("^seg", colnames(Z.main))])
    }
    if(any(grepl(".gen$", var.sel)))
    {
      var.sel = c(var.sel, colnames(Z.main)[grepl(".gen$", colnames(Z.main))])
    }
    var.col = which(colnames(Z.time) %in%  c("year_0609", "year_1417",
                                      outer(var.sel, c('_0609',"_1013","_1417"),
                                            paste0)))
    
    ps.exclude = rep(Inf,ncol(Z.time))
    ps.exclude[var.col] = 1
    if(missing(ps.lambda.old))
    {
      ps.ada = cv.glmnet.rep(cv.rep, Z.time, trt, family = "binomial",
                         alpha = 0, penalty.factor = ps.exclude,
                         offset = ps.offset.old)
      ps.coef.old = as.numeric(coef(ps.ada$fit, s= ps.ada$lambda.min))
      out$ps.lambda.old = ps.lambda.old = ps.ada$lambda.min
    }else
    {
      ps.ada = glmnet(Z.time, trt, family = "binomial",
                      alpha = 0, penalty.factor = ps.exclude,
                      offset = ps.offset.old)
      ps.coef.old = as.numeric(coef(ps.ada, s= ps.lambda.old))
    }
    ps.old = expit(drop(cbind(1,Z.time) %*% ps.coef.old)+ps.offset.old)
    
    names(ps.coef.old) = c("Intercept", colnames(Z.main))
    out$pos.exclude = pos.exclude = which(ps.old>0.9 | ps.old < 0.1)
  }
  
  if(length(pos.exclude)>0)
  {
    surv = surv[-pos.exclude]
    trt = trt[-pos.exclude]
    Z.main = Z.main[-pos.exclude,]
    Z.inter = Z.inter[-pos.exclude,]
    Z.inter.1 = Z.inter.1[-pos.exclude,]
    Z.time = Z.time[-pos.exclude,]
    Z.inter.time = Z.inter.time[-pos.exclude,]
    Z.inter.1.time = Z.inter.1.time[-pos.exclude,]
    ipcw.grp = ipcw.grp[-pos.exclude]
    proj.grp = proj.grp[-pos.exclude]
  }
  
  # OR
  if(missing(or.pen.off))
  {
    or.exclude = rep(1,1+ncol(Z.main)+ncol(Z.inter))
    or.exclude[which(apply(cbind(trt,Z.main,Z.inter)!=0, 2, sum)<20)] = Inf
    or.ridge = cv.glmnet.rep(cv.rep, cbind(trt,Z.main,Z.inter), surv,
                         family = "cox", penalty.factor = or.exclude, 
                         alpha = 0)
    
    out$or.pen.off = or.pen.off =  drop(1/abs(coef(or.ridge$fit, s = or.ridge$lambda.min)))
  }
  
  if(missing(or.lambda.off))
  {
    or.ada = cv.glmnet.rep(cv.rep, cbind(trt,Z.main,Z.inter), surv,
                       family = "cox",
                       alpha = 1, penalty.factor = or.pen.off)
    or.coef.off = as.numeric(coef(or.ada$fit, s= or.ada$lambda.min))
    out$or.lambda.off = or.lambda.off = or.ada$lambda.min
  }else
  {
    or.ada = glmnet(cbind(trt,Z.main,Z.inter), surv,
                    family = "cox", 
                    alpha = 1, penalty.factor = or.pen.off)
    or.coef.off = as.numeric(coef(or.ada, s= or.lambda.off))
  }
  
  or.offset = (trt * or.coef.off[1]+drop(Z.main %*% or.coef.off[1+1:ncol(Z.main)]) + 
    drop(Z.inter %*% or.coef.off[1+ncol(Z.main)+1:ncol(Z.inter)]))
  
  var.sel = c("LAC", c(colnames(Z.main),colnames(Z.inter))[or.coef.off[-1]!=0])
  if(any(grepl("^stage", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^stage", colnames(Z.main))])
  }
  if(any(grepl("^seg", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^seg", colnames(Z.main))])
  }
  if(any(grepl(".gen$", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl(".gen$", colnames(Z.main))])
  }
  if(any(grepl("^LAC_stage", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^LAC_stage", colnames(Z.inter))])
  }
  if(any(grepl("^LAC_seg", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^LAC_seg", colnames(Z.inter))])
  }
  if(any(grepl("LAC_[a-z]*.gen$", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("LAC_[a-z]*.gen$", colnames(Z.inter))])
  }
  var.col = which(c(colnames(Z.time),colnames(Z.inter.time))
                  %in%  c("year_0609", "year_1417",
                          outer(var.sel, c('_0609',"_1013","_1417"),
                                paste0)))
  
  or.exclude = rep(Inf,ncol(Z.time)+ncol(Z.inter.time))
  or.exclude[var.col] = 1
  if(missing(or.lambda))
  {
    or.ada = cv.glmnet.rep(cv.rep, cbind(Z.time,Z.inter.time), surv,
                       family = "cox",
                       alpha = 0, penalty.factor = or.exclude,
                       offset = or.offset)
    or.coef = as.numeric(coef(or.ada$fit, s= or.ada$lambda.min))
    out$or.lambda = or.lambda = or.ada$lambda.min
  }else
  {
    or.ada = glmnet(cbind(Z.time,Z.inter.time), surv,
                    family = "cox", 
                    alpha = 0, penalty.factor = or.exclude,
                    offset = or.offset)
    or.coef = as.numeric(coef(or.ada, s= or.lambda))
  }
  
  names(or.coef) = c(colnames(Z.time), 
                     colnames(Z.inter.time))
  
  pred = exp(drop(cbind(Z.time,Z.inter.time) %*% or.coef) + or.offset)
  hazfun = cox.breslow(pred,surv)
  
  # PS
  if(missing(ps.pen.off))
  {
    
    ps.exclude = rep(1,ncol(Z.main))
    ps.exclude[apply(Z.main!=0, 2, sum) < 20] = Inf
    ps.ridge = cv.glmnet.rep(cv.rep, Z.main, trt, 
                         family = "binomial", penalty.factor = ps.exclude,
                         alpha = 0)
    out$ps.pen.off = ps.pen.off = 1/abs(coef(ps.ridge$fit, s = ps.ridge$lambda.min)[-1])
  }
  if(missing(ps.lambda.off))
  {
    ps.ada = cv.glmnet.rep(cv.rep, Z.main, trt, 
                       family = "binomial",
                       penalty.factor = ps.pen.off)
    ps.coef.off = drop(coef(ps.ada$fit, s = ps.ada$lambda.min))
    ps.offset = ps.coef.off[1] + drop(Z.main %*% ps.coef.off[-1])
    out$ps.lambda.off = ps.lambda.off = ps.ada$lambda.min
  }else
  {
    ps.ada = glmnet(Z.main, trt,  
                    family = "binomial",
                    penalty.factor = ps.pen.off)
    ps.coef.off = drop(coef(ps.ada, s = ps.lambda.off))
    ps.offset = (ps.coef.off[1] + drop(Z.main %*% ps.coef.off[-1]))
  }
  var.sel = c("year", colnames(Z.main)[ps.coef.off[-1]!=0])
  if(any(grepl("^stage", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^stage", colnames(Z.main))])
  }
  if(any(grepl("^seg", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl("^seg", colnames(Z.main))])
  }
  if(any(grepl(".gen$", var.sel)))
  {
    var.sel = c(var.sel, colnames(Z.main)[grepl(".gen$", colnames(Z.main))])
  }
  var.col = which(colnames(Z.time) %in%  c("year_0609", "year_1417",
                                           outer(var.sel, c('_0609',"_1013","_1417"),
                                                 paste0)))
  
  ps.exclude = rep(Inf,ncol(Z.time))
  ps.exclude[var.col] = 1
  if(missing(ps.lambda))
  {
    ps.ada = cv.glmnet.rep(cv.rep, Z.time, trt, family = "binomial",
                       alpha = 0, penalty.factor = ps.exclude,
                       offset = ps.offset)
    ps.coef = as.numeric(coef(ps.ada$fit, s= ps.ada$lambda.min))
    out$ps.lambda = ps.lambda = ps.ada$lambda.min
  }else
  {
    ps.ada = glmnet(Z.time, trt, family = "binomial",
                    alpha = 0, penalty.factor = ps.exclude,
                    offset = ps.offset)
    ps.coef = as.numeric(coef(ps.ada, s= ps.lambda))
  }
  ps = expit(drop(cbind(1,Z.time) %*% ps.coef) + ps.offset)

  
  # Censoring distribution
  n = length(surv)
  ipcw = rep(0,n)
  for(lev in levels(ipcw.grp))
  {
    lev0 = (trt==0)&(ipcw.grp==lev)
    lev1 = (trt==1)&(ipcw.grp==lev)
    G0 = survfit(Surv(surv[,1],1-surv[,2])~1, subset = lev0)
    G1 = survfit(Surv(surv[,1],1-surv[,2])~1, subset = lev1)
    ipcw[lev0] = 1/stepfun(G0$time, c(1,G0$surv))(pmin(surv[lev0,1],max.year))
    ipcw[lev1] = 1/stepfun(G1$time, c(1,G1$surv))(pmin(surv[lev1,1],max.year))
  }
  ipcw = ipcw*surv[,2]
  
  # Calculating the ATE
  #=============================================
  
  time.grid = sort(unique(surv[surv[,2]==1,1]))
  time.grid = time.grid[time.grid <= max.year]
  mu1.all = mu0.all = data.frame(time = time.grid)
  
  # Across all years
  #---------------------------------------------
  
  
  # OR prediction
  haz = hazfun(time.grid)
  
  pred1 = exp(drop(cbind(1, Z.main, Z.inter.1) %*% or.coef.off)
              + drop(cbind(Z.time, Z.inter.1.time) %*% or.coef))
  pred0 = exp(drop(cbind(0, Z.main, 0*Z.inter.1) %*% or.coef.off)
              + drop(cbind(Z.time, 0*Z.inter.1.time) %*% or.coef))
  
  mu1.all$OR = apply(exp(-outer(pred1,haz)),2,mean)
  mu0.all$OR = apply(exp(-outer(pred0,haz)),2,mean)
  
  # IPW prediction
  Y.dich = outer(surv[,1], time.grid, "<=")*ipcw
  iptw1 = trt/ps
  iptw0 = (1-trt)/(1-ps)
  mu1.all$IPW = 1-apply(Y.dich *iptw1 ,2,mean)
  mu0.all$IPW = 1-apply(Y.dich *iptw0 ,2,mean)
  
  # DR prediction
  mu1.all$DR = mu1.all$OR + mu1.all$IPW - 1+ apply((1-exp(-outer(pred1,haz)))*iptw1,2,mean)
  mu0.all$DR = mu0.all$OR + mu0.all$IPW - 1 + apply((1-exp(-outer(pred0,haz)))*iptw0,2,mean)
  
  # Stratified by years: 2006-2017
  #---------------------------------------------
  
  mu1.year = mu0.year = vector("list",nlevels(proj.grp))
  names(mu1.year) = names(mu0.year) = levels(proj.grp)
  
  # Fit density ratio model
  bal.var = colnames(Z.rct)
  
  out$dr.coef = list()
  if(missing(dr.pen))
  {
    out$dr.pen = dr.pen =  vector("list", nlevels(proj.grp))
    names(out$dr.pen) = names(dr.pen) = levels(proj.grp)
  }
  if(missing(dr.lambda))
  {
    out$dr.lambda = dr.lambda =  rep(NA, nlevels(proj.grp))
    names(out$dr.lambda) = names(dr.lambda) = levels(proj.grp)
  }
  for (lev in levels(proj.grp)) 
  {
    lev.pos = proj.grp == lev
    if(is.null(dr.pen[[lev]]))
    {
      dr.ridge = cv.glmnet.rep(cv.rep, rbind(Z.main[lev.pos,bal.var],
                                 Z.rct), 
                           rep(0:1, c(sum(lev.pos),nrow(Z.rct))),
                           family = "binomial",
                           alpha = 0)
      out$dr.pen[[lev]] = dr.pen[[lev]] = 1/abs(coef(dr.ridge$fit, s = dr.ridge$lambda.min)[-1])
    }
    if(is.na(dr.lambda[lev]))
    {
      dr.ada = cv.glmnet.rep(cv.rep, rbind(Z.main[lev.pos,bal.var],
                               Z.rct), 
                         rep(0:1, c(sum(lev.pos),nrow(Z.rct))),
                         family = "binomial",
                         alpha = 1, penalty.factor = dr.pen[[lev]])
      out$dr.coef[[lev]] = dr.coef = as.numeric(coef(dr.ada$fit, s= dr.ridge$lambda.min))
      out$dr.lambda[lev] = dr.lambda[lev] = dr.ada$lambda.min
    }else
    {
      dr.ada = glmnet(rbind(Z.main[lev.pos,bal.var],
                            Z.rct), 
                      rep(0:1, c(sum(lev.pos),nrow(Z.rct))),
                      family = "binomial",
                      alpha = 1, penalty.factor = dr.pen[[lev]])
      out$dr.coef[[lev]] = as.numeric(coef(dr.ada, s= dr.lambda[lev]))
    }
    names(out$dr.coef[[lev]]) = c("Intercept",colnames(Z.main[,bal.var]))
  }
  
  # target population: RCT
  for(target in levels(proj.grp))
  {
    # Target year 2014-2017
    lev = target
    mu1.year[[lev]]  = mu0.year[[lev]]  = data.frame(time = time.grid)
    lev.pos = proj.grp == lev
    
    dr = exp(-drop(cbind(1,Z.main[lev.pos,bal.var]) %*% out$dr.coef[[lev]]))
    dr = dr/mean(dr)
    # OR prediction
    haz = hazfun(time.grid)
    
    mu1.year[[target]] $OR = apply(exp(-outer(pred1[lev.pos],haz))*dr,2,mean)
    mu0.year[[target]] $OR = apply(exp(-outer(pred0[lev.pos],haz))*dr,2,mean)
    
    # IPW prediction
    iptw1.lev = iptw1[lev.pos]*dr/mean(iptw1[lev.pos]*dr)
    iptw0.lev = iptw0[lev.pos]*dr/mean(iptw0[lev.pos]*dr)
    
    Y.dich = outer(surv[lev.pos,1], time.grid, "<=")*ipcw[lev.pos]
    mu1.year[[target]] $IPW = 1-apply(Y.dich *iptw1.lev ,2,mean)
    mu0.year[[target]] $IPW = 1-apply(Y.dich *iptw0.lev ,2,mean)
    
    # DR prediction
    mu1.year[[target]] $DR = (mu1.year[[target]]$OR + mu1.year[[target]]$IPW - 1+
                                apply((1-exp(-outer(pred1[lev.pos],haz)))*iptw1.lev,2,mean))
    mu0.year[[target]] $DR = (mu0.year[[target]]$OR + mu0.year[[target]]$IPW - 1 +
                                apply((1-exp(-outer(pred0[lev.pos],haz)))*iptw0.lev,2,mean))
  }
  
  
  
  return(c(list(mu1.all = mu1.all, mu0.all = mu0.all, 
                mu1.year = mu1.year, mu0.year = mu0.year, 
                or.coef = or.coef,  or.coef.off = or.coef.off,
                ps.coef = ps.coef, ps.coef.off = ps.coef.off),out))
  
  
}

rm(list = objects())


pak.list = c("glmnet", "ggplot2", "gridExtra", "grid", "survival"
             # ,"doParallel", "doRNG"
             )

for (pak in pak.list)
{
  yo = require(pak, character.only = T)
  if(!yo)
  {
    install.packages(pak,repos = "http://cran.us.r-project.org")
    require(pak, character.only = T)
  }
}
source("utility.R")
source("paper_surg_phecode_by_year.R")

load("paper1_elig_phecode.rda")
load("paper_surg_analysis.rda")

n = length(surv)
nrct = length(surv.rct)
B = 1000

surv[id %in% death0609,2] = 1
boot.fit.death = vector("list", B)
for (b in 1:B) 
{
  print(b)
  start.time = Sys.time()
  Boot.rct = sample(1:nrct, nrct, replace = T)
  Boot.ehr = sample(1:n, n, replace = T)
  
  boot.fit.death[[b]] = ate.ehr.phecode.by.year(surv[Boot.ehr],trt[Boot.ehr],
                                                   Z.main[Boot.ehr,], Z.inter[Boot.ehr,], Z.inter.1[Boot.ehr,], 
                                                   Z.time[Boot.ehr,], Z.inter.time[Boot.ehr,], Z.inter.1.time[Boot.ehr,], 
                                    year.grp[Boot.ehr],year.grp[Boot.ehr],
                                    surv.rct[Boot.rct], trt.rct[Boot.rct], Z.rct[Boot.rct,],
                                    or.pen.off = fit.death$or.pen.off, 
                                    or.lambda.off = fit.death$or.lambda.off, 
                                    or.lambda = fit.death$or.lambda,
                                    ps.pen.old.off = fit.death$ps.pen.old.off,   
                                    ps.lambda.old.off = fit.death$ps.lambda.old.off, 
                                    ps.lambda.old = fit.death$ps.lambda.old,
                                    ps.pen.off = fit.death$ps.pen.off,  
                                    ps.lambda.off = fit.death$ps.lambda.off, 
                                    ps.lambda = fit.death$ps.lambda,
                                    pos.exclude = fit.death$pos.exclude, 
                                    dr.pen = fit.death$dr.pen, 
                                    dr.lambda  = fit.death$dr.lambda
  )
  run.time = Sys.time() - start.time
  
  print(run.time)
}


save( boot.fit.death, 
     file = paste0("result/analysis/paper_surg_analysis24_boot.rda"))



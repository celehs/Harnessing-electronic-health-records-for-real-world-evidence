expit = function(x)
{
  return(1/(1+exp(-x)))
}

dexpit = function(x)
{
  return(expit(x)*(1-expit(x)))
}

logit = function(x)
{
  return(-log(1/x - 1))
}

logistic.dev = function(Y,lp,weights = rep(1,length(Y)))
{
  if(is.null(dim(lp)))
   return(sum(weights*(log(1+exp(lp)) - Y*lp))/sum(weights))
  else
    return(apply(weights*(log(1+exp(lp)) - Y*lp),2,sum)/sum(weights))
}

cox.breslow = function(rr,surv)
{
  x.order = order(surv[,1])
  d = surv[x.order,2]
  x = surv[x.order,1]
  rr = rr[x.order]
  
  at.risk = rev(cumsum(rev(rr)))
  tie.last = rev(!duplicated(rev(x))) & (d==1)
  haz = diff(c(0, cumsum(d)[tie.last]))/at.risk[tie.last]
  
  return(stepfun(x[tie.last], c(0,cumsum(haz))))
}
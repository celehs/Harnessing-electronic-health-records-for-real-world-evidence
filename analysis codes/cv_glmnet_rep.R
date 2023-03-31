cv.glmnet.rep = function(nrep, ...)
{
  full.fit = glmnet(...)
  
  cvm = rep(0, length(full.fit$lambda))
  
  for (irep in 1:nrep)
  {
    cvm =  cvm + cv.glmnet(...)$cvm/nrep
  }
  
  return(list(fit = full.fit, cvm = cvm, lambda = full.fit$lambda, 
              lambda.min = full.fit$lambda[which.min(cvm)]))
}
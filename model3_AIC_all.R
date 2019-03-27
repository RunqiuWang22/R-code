#AIC backward for all covariates
library(MASS)
f = as.formula(paste('Surv(time,event)','~',paste(names(all.train)[1:(dim(all.train)[2]-2)],collapse = "+")))
cox_AIC=coxph(f, data=all.train,x=T,y=T)
set.seed(1111)
cox_model_all=stepAIC(cox_AIC, direction="backward",trace = F)
save(cox_model_all, file = "/Users/wangrunqiu/Downloads/practicum/result/model3_AIC.Rdata")
#top_10
top10=names(sort(summary(cox_model_all)$coefficients[,5],decreasing = F)[1:10])
f_10=as.formula(paste('Surv(time,event)','~',paste(top10,collapse = "+")))
AIC_10=coxph(f_10, data=all.train,x=T,y=T)
save(AIC_10, file = "/Users/wangrunqiu/Downloads/practicum/result/AIC_10.Rdata")


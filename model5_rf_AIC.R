#rf_AIC
library(MASS)
f = as.formula(paste('Surv(time,event)','~',paste(rownames(rf_sort)[1:10],collapse = "+")))
cox_AIC=coxph(f, data=all.train,x=T,y=T)
rf_AIC.cox=stepAIC(cox_AIC, direction="backward",trace=F)

save(rf_AIC.cox, file = "/Users/wangrunqiu/Downloads/practicum/result/model5_rf_AIC.Rdata")

HR=round(summary(cox_model)$conf.int[,1],3)
LC=round(summary(cox_model)$conf.int[,3],3)
UC=round(summary(cox_model)$conf.int[,4],3)
a=paste(HR,'(',LC,'-',UC,')')
b=summary(cox_model)$coefficients[,5]
c=cbind(a,b)
write.csv(c,'/Users/wangrunqiu/Downloads/practicum/result/stroke_rf_AIC.csv')
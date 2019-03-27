a=rep(0,10)
b=rep(0,10)
for(i in 1:10) {
  cox_model_uni=coxph(Surv(strokefu, stroke)~cox_complete[,i], data=cox_complete)
  HR=round(summary(cox_model_uni)$conf.int[1],3)
  LC=round(summary(cox_model_uni)$conf.int[3],3)
  UC=round(summary(cox_model_uni)$conf.int[4],3)
  a[i]=paste(HR,'(',LC,'-',UC,')')
  b[i]=summary(cox_model_uni)$coefficients[5]
}
c=cbind(a,b)
write.csv(c,"/Users/wangrunqiu/Downloads/ACC 2019/Zyannah Mallick/stroke_univariate.csv")


HR=round(summary(cox_model)$conf.int[,1],3)
LC=round(summary(cox_model)$conf.int[,3],3)
UC=round(summary(cox_model)$conf.int[,4],3)
a=paste(HR,'(',LC,'-',UC,')')
b=summary(cox_model)$coefficients[,5]
c=cbind(a,b)
write.csv(c,"/Users/wangrunqiu/Downloads/ACC 2019/Zyannah Mallick/death_multivariate_AIC.csv")
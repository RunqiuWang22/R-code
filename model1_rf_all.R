library(pec)
library(riskRegression)
library(survival)
library(randomForestSRC)
library(ROCR)
#dummy variable Random forests for all covariates(trainning data)
seed=1111
set.seed(seed)
rf=rfsrc(Surv(time, event)~.,data = all.train,
         ntree = 5000,tree.err=TRUE, importance=TRUE,splitrule = 'logrank')
save(rf, file = "/Users/wangrunqiu/Downloads/practicum/result/model1_rf_all.Rdata")
#VIMP method to rank the importance
#plot(rf)
rf_sort=sort(rf$importance, decreasing=T)
rf_sort=as.data.frame(rf_sort) #relative importance 除以本身
write.csv(rf_sort,'/Users/wangrunqiu/Downloads/practicum/result/random forest_train_stroke.csv')
#temp=max.subtree(rf)
#depth_rank = temp$order[order(temp$order[,1]),1]
#write.csv(depth_rank,'/Users/wangrunqiu/Downloads/practicum/result/random forest_train_mini depth_dummy.csv')

#top 10
#top_10
f_10=as.formula(paste('Surv(time,event)','~',paste(rownames(rf_sort)[1:10],collapse = "+")))
rf_10=coxph(f_10, data=all.train,x=T,y=T)
save(rf_10, file = "/Users/wangrunqiu/Downloads/practicum/result/rf_10.Rdata")
# univaritae analysis
a=rep(0,10)
b=rep(0,10)
for(i in 1:10) {
  cox_model_uni=coxph(Surv(time, event)~all.train[,names(all.train)%in%rownames(rf_sort)[i]], data=all.train)
  HR=round(summary(cox_model_uni)$conf.int[1],3)
  LC=round(summary(cox_model_uni)$conf.int[3],3)
  UC=round(summary(cox_model_uni)$conf.int[4],3)
  a[i]=paste(HR,'(',LC,'-',UC,')')
  b[i]=summary(cox_model_uni)$coefficients[5]
}
c=cbind(rownames(rf_sort)[1:10],a,b)
write.csv(c,'/Users/wangrunqiu/Downloads/practicum/result/stroke.csv')





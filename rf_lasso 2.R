#rf_lasso
#rf_sort_10=depth_rank[1:10]
#names(depth_rank)[1:10]
rf_10=all.train[,which(names(all.train)%in%c(rownames(rf_sort)[1:10],'time','event'))]
#lasso
library(glmnet)
#x_10 = model.matrix(Surv(time, event)~., rf_10)[,-1] #12 column
#y_10 = with(rf_10, Surv(time, event))
x_10 = as.matrix(rf_10[,!names(rf_10)%in% c('time','event')])
y_10 = with(rf_10, Surv(time, event))
set.seed(1234)
lasso.cv_10 = cv.glmnet(x_10, y_10, family = 'cox',
                     alpha = 1, standardize = F, 
                     nlambda = 100)

lasso.coef_10 = glmnet(x_10, y_10, family = 'cox',
                    alpha = 1, standardize = F, 
                    nlambda = 100,lambda = 0.01 )#lasso.cv_10$lambda.min
rf_lasso_index=which(abs(lasso.coef_10$beta)>0)
#rf_lasso=data.frame(x_10,rf_10$time,rf_10$event)
#colnames(rf_lasso)[c(dim(rf_lasso)[2]-1,dim(rf_lasso)[2])]=c('time','event')
f = as.formula(paste('Surv(time,event)','~',paste(names(as.data.frame(x_10))[rf_lasso_index],collapse = "+")))
rf_lasso.cox = coxph(f,data=all.train,x=T,y=T)
HR=round(summary(rf_lasso.cox)$conf.int[,1],3)
LC=round(summary(rf_lasso.cox)$conf.int[,3],3)
UC=round(summary(rf_lasso.cox)$conf.int[,4],3)
a=paste(HR,'(',LC,'-',UC,')')
b=summary(rf_lasso.cox)$coefficients[,5]
c=cbind(a,b)
write.csv(c,'/Users/wangrunqiu/Downloads/practicum/result/stroke_rf_lasso.csv')
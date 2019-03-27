library(glmnet)
#x = model.matrix(Surv(time, event)~., all.train)[,-1] #96 column
#y = with(all.train, Surv(time, event))
x = as.matrix(all.train[,!names(all.train)%in% c('time','event')])
y = with(all.train, Surv(time, event))

set.seed(1234)
lasso.cv = cv.glmnet(x, y, family = 'cox',
                     alpha = 1, standardize = F, 
                     nlambda = 100)

lasso.coef = glmnet(x, y, family = 'cox',
                    alpha = 1, standardize = F, 
                    nlambda = 100,lambda = lasso.cv$lambda.min)
index=which(abs(lasso.coef$beta)>0) # 50 variable are selected
#all.train1=data.frame(x,all.train$time,all.train$event)
#colnames(all.train1)[c(dim(all.train1)[2]-1,dim(all.train1)[2])]=c('time','event')
f = as.formula(paste('Surv(time,event)','~',paste(names(as.data.frame(x))[index],collapse = "+")))
lasso.cox = coxph(f,data=all.train,x=T,y=T)
save(lasso.cox, file = "/Users/wangrunqiu/Downloads/practicum/result/model2_lasso_all.Rdata")

#top_10
top10=names(sort(summary(lasso.cox)$coefficients[,5],decreasing = F)[1:10])
f_10=as.formula(paste('Surv(time,event)','~',paste(top10,collapse = "+")))
lasso_10=coxph(f_10, data=all.train,x=T,y=T)
save(lasso_10, file = "/Users/wangrunqiu/Downloads/practicum/result/lasso_10.Rdata")
           
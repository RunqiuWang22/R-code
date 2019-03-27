library(CoxBoost)
x = as.matrix(all.train[,!names(all.train)%in% c('time','event')])
set.seed(1111)
cv.res=cv.CoxBoost(time=all.train$time,status=all.train$event,x=x,maxstepno=500,
                      K=10,type="verweij",penalty=100)
cbfit=CoxBoost(time=all.train$time,status=all.train$event,x=x,stepno=cv.res$optimal.step,penalty=100)
boost.coef=coef(cbfit,at.step = cv.res$optimal.step,scale=F)
index.boost=which(abs(boost.coef)>0) # 28 variable are selected
f = as.formula(paste('Surv(time,event)','~',paste(names(as.data.frame(x))[index.boost],collapse = "+")))
boost.cox = coxph(f,data=all.train,x=T,y=T)
save(boost.cox, file = "/Users/wangrunqiu/Downloads/practicum/result/model6_boost.Rdata")
##top_10
top10=names(sort(summary(boost.cox)$coefficients[,5],decreasing = F)[1:10])
f_10=as.formula(paste('Surv(time,event)','~',paste(top10,collapse = "+")))
boost_10=coxph(f_10, data=all.train,x=T,y=T)
save(boost_10, file = "/Users/wangrunqiu/Downloads/practicum/result/boost_10.Rdata")
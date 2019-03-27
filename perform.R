library(pec)
library(riskRegression)
library(survival)
library(randomForestSRC)
library(ROCR)
setwd('/Users/wangrunqiu/Downloads/practicum/result/stroke')
load('model1_rf_all.Rdata')
load('model2_lasso_all.Rdata')
load('model3_AIC.Rdata')
load('model4_rf_lasso.Rdata')
load('model5_rf_AIC.Rdata')
load('model6_boost.Rdata')
load('rf_10.Rdata')

obj.lst=list('rf_all' = rf,'boost'=boost.cox,'Lasso'=lasso.cox,
             'AIC' = cox_model_all,'rf_10'=rf_10,'RF_Lasso' = rf_lasso.cox,
             'RF_AIC' = rf_AIC.cox)

#obj.lst=list('Random Forests' = rf,'rf_10'=rf_10,'Lasso_10'=lasso_10,
#             'AIC_10'=AIC_10,'RF_Lasso' = rf_lasso.cox,
#             'RF_AIC' = rf_AIC.cox,'boost_10'=boost_10)

#Brier score
pec.obj = pec(object = obj.lst,
              formula = Hist(time, event)~1,
              data = all.valid,
              times = seq(min(all.valid$time),max(all.valid$time),by=365.25),
              splitMethod = 'none',
              cens.model = 'marginal',reference=F)
print(pec.obj)

#c-index
# c index
ApparrentCindex  <- pec::cindex(object = obj.lst,
                  formula = Hist(time, event)~1,
                  data = all.valid,
                  eval.time = seq(min(all.valid$time),max(all.valid$time),by=365.25),
                  splitMethod = 'none',
                  cens.model = 'marginal')
c.index=print(ApparrentCindex$AppCindex)
write.csv(c.index,'/Users/wangrunqiu/Downloads/practicum/result/new_c-index_stroke.csv')

par(mfrow = c(1,2))
plot(pec.obj,xlab='day',legend=F)
legend('topleft', 
       legend = c('rf_all','boost','Lasso','AIC','rf_10','RF_Lasso',
                  'RF_AIC', ),
       lty = 1, col = 1:7, bty = 'n',
       horiz = F, seg.len = 2,cex=0.7)

#poster
par(mfrow = c(1,1))
plot(ApparrentCindex, xlab = 'day',legend=F)
legend('topleft', 
              legend = c('rf_all','boost','Lasso','AIC','rf_10','RF_Lasso',
                         'RF_AIC'),
              lty = 1, col = 1:7, bty = 'n',
              horiz = F, seg.len = 2,cex=0.9)







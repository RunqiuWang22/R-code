rm(list = ls())
all_data=read.csv('/Users/wangrunqiu/Downloads/practicum/data/imputed.data.csv')
all_data[,c(2:7,9:24,30:34,38:41,43,51:54,69:76,78,81,83)]=lapply(all_data[,c(2:7,9:24,30:34,38:41,43,51:54,69:76,78,81,83)],factor)
# subset the data to include all the covariates and the two outcome variable (Follow-up time and event indicator)
#death
data_death=all_data[,2:86]
#mi
data_mi=all_data[ ,c(2:84, 96, 97)]
#stroke
data_stroke=all_data[ ,c(2:84, 98, 99)]
write.csv(data_death,'/Users/wangrunqiu/Downloads/practicum/data/death data.csv')
write.csv(data_mi,'/Users/wangrunqiu/Downloads/practicum/data/mi data.csv')
write.csv(data_stroke,'/Users/wangrunqiu/Downloads/practicum/data/stroke data.csv')





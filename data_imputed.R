rm(list = ls())
# firsrt read the csv file based on your path 
zyannah= read.csv("/Users/wangrunqiu/Downloads/practicum/data/baseline_and_endpoints_BARI2D.csv",header=T)
dim(zyannah) # numble of rows and columns 
names(zyannah)

# missing proportions of the columns 
apply(zyannah, 2, function(col) sum(is.na(col))/length(col))
# delete the columns which has missing proportions > 0.5 
zyannah1= zyannah[colSums(is.na(zyannah)/nrow(zyannah))< 0.5] 


zyannah1[,c(2:7,9:24,30:34,38:41,43,51:54,69:76,78,81,83)]=lapply(zyannah1[,c(2:7,9:24,30:34,38:41,43,51:54,69:76,78,81,83)],factor)
library(tableone)
charac=CreateTableOne(data=zyannah1[,2:84])

#impute the data
library(randomForestSRC)
dat.imp = impute.rfsrc(data = zyannah1,
                       ntree = 1000,
                       na.action = 'na.impute')

### change the levels of strata to Yes or No 
levels(dat.imp$strata)
levels(dat.imp$strata)[levels(dat.imp$strata)=="CABG"]="Not"
levels(dat.imp$strata)[levels(dat.imp$strata)=="PCI"]="Yes"
levels(dat.imp$strata)
write.csv(dat.imp,'/Users/wangrunqiu/Downloads/practicum/data/imputed.data.csv')

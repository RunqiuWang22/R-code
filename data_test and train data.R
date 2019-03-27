rm(list = ls())
library(survival)
library(randomForestSRC)
# stratified sampling
#data=read.csv('/Users/wangrunqiu/Downloads/practicum/data/death data.csv')
#data=read.csv('/Users/wangrunqiu/Downloads/practicum/data/mi data.csv')
data=read.csv('/Users/wangrunqiu/Downloads/practicum/data/stroke data.csv')
index=c(2:7,9:24,30:34,38:41,43,51:54,69:76,78,81,83)
data[,index-1]=lapply(data[,index-1],factor)
dim(data)
str(data)
data$time = as.double(data$time)
data$event = as.double (data$event)
#check see any negative event times
data=data[data$time>0,]
seed = 1111
dat.event = data[data$event == 1,]
dat.nonevent = data[data$event == 0,]
# stratified sample size
N.event = dim(dat.event)[1]
N.nonevent = dim(dat.nonevent)[1]
# sample from each stratum
set.seed(seed)
valid.event = sample(N.event, round(N.event/3))
set.seed(seed)
valid.nonevent = sample(N.nonevent, round(N.nonevent/3))

# compile training and test data
all.valid = rbind(dat.event[valid.event,],
                  dat.nonevent[valid.nonevent,])
all.train = rbind(dat.event[-valid.event,],
                  dat.nonevent[-valid.nonevent,])

#transform data into dummy variable
x = model.matrix(Surv(time, event)~., data)[,-1] #96 column
y = with(data, Surv(time, event))
data1=data.frame(x,data$time,data$event)
colnames(data1)[c(dim(data1)[2]-1,dim(data1)[2])]=c('time','event')
seed = 1111
dat.event = data1[data1$event == 1,]
dat.nonevent = data1[data1$event == 0,]
# stratified sample size
N.event = dim(dat.event)[1]
N.nonevent = dim(dat.nonevent)[1]
# sample from each stratum
set.seed(seed)
valid.event = sample(N.event, round(N.event/3))
set.seed(seed)
valid.nonevent = sample(N.nonevent, round(N.nonevent/3))

# compile training and test data
all.valid = rbind(dat.event[valid.event,],
                  dat.nonevent[valid.nonevent,])
all.train = rbind(dat.event[-valid.event,],
                  dat.nonevent[-valid.nonevent,])



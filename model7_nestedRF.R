# load library
library(randomForestSRC)
library(pec)
library(riskRegression)
library(survival)
library(beepr)
library(glmnet)
library(MASS)
library(doParallel)


# load data label
load(paste(curr.dir, 'mesa_label60.Rdata', sep = ''))
# load training data
load(paste(curr.dir, 'all_training60.Rdata', sep = ''))
# load validation data
load(paste(curr.dir, 'all_validation60.Rdata', sep = ''))

#==================================================================
# RF by variable numbers
#==================================================================
# options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)
seed = 4995

print('read in variables ordered by rank')
var.order = read.csv(file = paste(curr.dir, 'depth_rank60.csv', sep = ''), 
                     header = T)
var.order = var.order[, all.events]
var.order = apply(var.order, 2, as.character)

pe.c = NULL
ptm = proc.time()

for (ind in 1:7){
  print(paste('outcome', all.events[ind]))
  
  ptmi = proc.time()
  pe.c[[ind]] = mclapply(c(1:19, seq(20, 100, by = 10), seq(110, 735, by = 20), 735),
                         function(i){
                           print(paste('number of variables  =', i))
                           
                           n.top = i
                           dat = all.train[[ind]][, c('time', 'event',
                                                      var.order[, ind][1:n.top])]
                           
                           # RF objects
                           set.seed(seed)
                           rf.obj = rfsrc(Surv(time, event)~.,
                                          data = dat,
                                          ntree = 1000,
                                          splitrule = 'logrank')
                           
                           # External
                           rf.pe = pec(list(rf.obj),
                                       formula = Hist(time, event)~1,
                                       data = all.valid[[ind]],
                                       times = min(365.25*12, 
                                                   max(all.valid[[ind]]$time)), 
                                       exact = T,
                                       splitMethod = 'none',
                                       cens.model = 'marginal')
                           rf.c = cindex(list(rf.obj),
                                         formula = Hist(time, event)~1,
                                         data = all.valid[[ind]],
                                         eval.times = 365.25*12,
                                         splitMethod = 'none',
                                         cens.model = 'marginal')
                           pe.external = rf.pe$AppErr$rfsrc[
                             which(rf.pe$time == min(365.25*12, 
                                                     max(all.valid[[ind]]$time)))][1]
                           c.external = rf.c$AppCindex
                           
                           return(c(n.top, 
                                    pe.external,
                                    c.external))
                         }, mc.cores = detectCores())
  
  pe.c[[ind]] = data.frame(do.call(rbind, pe.c[[ind]]))
  names(pe.c[[ind]]) = c('n.top', 'pe.external', 'c.external')
  
  save(pe.c, file = paste(curr.dir, 'PEC_nestedRF.Rdata', sep = ''))
  
  print(proc.time() - ptmi)
}

print(proc.time() - ptm)
beep()

save(pe.c, file = paste(curr.dir, 'PEC_nestedRF.Rdata', sep = ''))

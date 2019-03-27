# R-code
thesis
#==================================================================

# This file describes the general order to run the script.
#### Not all the scripts need to be run.  Only run what's necessary.
#### If anything does not run properly, it is possibly due to package update.
#### In that case, use the following checkpoint 

# library(checkpoint)
# checkpoint('2015-10-01')


#==================================================================
# Data preparation
#------------------------------------------------------------------
# Missing data imputation
#### Impute missing data using Random Forest

data_impute.R

#------------------------------------------------------------------

# Split data into training set and validation set
#### 2/3 data for model training
#### 1/3 data for model validation
#### Splittng is stratified by outcome so that training and validation set have equal percentage of event

data_split.R


#==================================================================
# Model Building
#### All of the model scripts can be run similarly in MARCC 
#### They are parallelized to the maximum cores of the machine
#------------------------------------------------------------------

# Model 1:  Random Forest model with all variables
#### Build Ranndom Forest model
#### Get variable importance and minimal depth of maximal subtree
#### Get top 20 variables for each outcome

model1_rf_all.R

#------------------------------------------------------------------
# Model 2: LASSO Cox with all variable
#### Can be skipped since models for most outcome would not converge

model2_lasso_all.R

#------------------------------------------------------------------

# Model 3: AIC Cox with all variables
#### Cox model with AIC backward selection
model3_AIC_all.R

#------------------------------------------------------------------

# Model 4: LASSO Cox with top 20 variables

model4_rf_lasso.R

#------------------------------------------------------------------

# Model 5: AIC Cox with top 20 variables
model5_rf_AIC.R


#------------------------------------------------------------------

# Model 6: Boosting model with all variables

model6_Boosting_all.R

#------------------------------------------------------------------
# Model 7: Nested Random Forest model
#### Build nested random forest model by sequentially adding covariates ranked by minimum depth of maximal subtree
#### Performance of the nested model is evaluated at year 12
#### May not work on MARCC due to its retriction on the number of processes

model7_nestedRF.R

#------------------------------------------------------------------

# Performance Evaluation & Model Comparison
#### Compute C index and Brier score at year 12
#### Plot C index and Brier score over time

perform.R


#------------------------------------------------------------------

###univariate analysis
univariate analysis.R


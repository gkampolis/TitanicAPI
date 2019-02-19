# Intro Comments ----------------------------------------------------------

# This script loads the model and sets up the API. It assumes that
# `createModel.R` has already been run and that the model and dataframe are
# present in the `model`` folder, along with the parameter validation script
# `valParams.R`. Note that there is no restriction as to where the model was
# run, the files can be cloned later if desired into the docker container.

# It is assumed that the script is called from `runAPI.R`, and that the
# relevant packages (mlr and plumbr) are loaded.

# Created by George Kampolis.


# Load Model, Data Set and Validation Function ----------------------------

library(mlr)

titanicModel <- readRDS("model/titanicModel.rds")

titanicNewData <- readRDS("model/titanicNewData.rds")


source("model/valParams.R")


# Prediction API ----------------------------------------------------------


#' Predict survival on the titanic
#' @param pClass:int Class of passenger. Possible values: 1, 2 or 3.
#' @param pSex:character Sex of passenger. Possible values: male or female.
#' @param pAge:numeric Age of passenger in years. Numeric.
#' @param pFare:numeric Fare paid by passenger in pounds £. Numeric
#' @param pFamily:int No. of family members on board. Integer.
#' @get /titanic
function(pClass, pSex, pAge, pFare, pFamily){
  
  # validate parameters passed
  valResult <- valParams(pClass, pSex, pAge, pFare, pFamily)
  
  # make predictions if valid parameters are supplied ----
  if(isTRUE(valResult)){
    titanicNewData$class[1] <<- factor(pClass, levels=levels(titanicNewData$class))
    titanicNewData$sex[1] <<- factor(pSex, levels=levels(titanicNewData$sex))
    titanicNewData$age[1] <<- as.numeric(pAge)
    titanicNewData$fare[1] <<- as.numeric(pFare)
    titanicNewData$familyOnBoard <<- as.integer(pFamily)
    pred <- predict(object = titanicModel, newdata = as.data.frame(titanicNewData))
    return(as.data.frame(pred))
  } else {
    return(valResult)
  }
}

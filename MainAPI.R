# Intro Comments ----------------------------------------------------------

# This script loads the model and sets up the API. It assumes that
# "createModel.R" has already been run and that the model and dataframe are
# present in the "model" folder, along with the parameter validation script
# "valParams.R". Note that there is no restriction as to where the model was
# run, this can be cloned into the docker container along with the model.

# It is assumed that the script is called from `RunAPI.R`, and that the
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
    titanicNewData$class[1] <<- as.factor(pClass)
    titanicNewData$sex[1] <<- as.factor(pSex)
    titanicNewData$age[1] <<- as.numeric(pAge)
    titanicNewData$fare[1] <<- as.numeric(pFare)
    titanicNewData$familyOnBoard <<- as.integer(pFamily)
    pred <- predict(object = titanicModel, newdata = titanicNewData)
    return(as.data.frame(pred))
  } else {
    return(valResult)
  }
}

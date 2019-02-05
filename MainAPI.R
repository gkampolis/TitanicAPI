# Intro Comments ----------------------------------------------------------

# This script loads the model and sets up the API. 
# It assumes that "createModel.R" has already been
# run and that the model and dataframe are present
# in the "model" folder. Note that there's no re-
# striction as to where the model was run, this can
# be cloned into the docker container along with the
# model.

# It is assumed that the script is called from `RunAPI.R`,
# and that the relevant packages (mlr and plumbr) are loaded.

# Created by George Kampolis.


# Load Model And Data Set -------------------------------------------------

titanicModel <- readRDS("model/titanicModel.rds")

titanicNewData <- readRDS("model/titanicNewData.rds")


# Prediction API ----------------------------------------------------------


#' Predict survival on the titanic
#' @param pClass Class of passenger
#' @param pSex Sex of passenger
#' @param pAge Age of passenger in years
#' @param pFare Fare paid by passenger in £
#' @param pFamily No. of family members on board
#' @get /titanic
function(pClass, pSex, pAge, pFare, pFamily){
  titanicNewData$class[1] <- as.factor(pClass)
  titanicNewData$sex[1] <- as.factor(pSex)
  titanicNewData$age[1] <- as.numeric(pAge)
  titanicNewData$fare[1] <- as.numeric(pFare)
  titanicNewData$familyOnBoard <- as.integer(pFamily)
  predict(object = titanicModel, newdata = titanicNewData)
}

# Intro Comments ----------------------------------------------------------

# This script loads the model and sets up the API. It assumes that
# `createModel.R` has already been run and that the model and dataframe are
# present in the `model` folder, along with the parameter validation script
# `valParams.R`. Note that there is no restriction as to where the model was
# run, the files can be cloned later if desired into the docker container.

# Endpoints: 
# "/" : used for a simple html welcome screen.
# "/titanic" : used to serve predictions. 

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



# Intro Page --------------------------------------------------------------

# Simple into page just to give an idea of what's going.

#' Welcome to the Titanic API
#' @get /
#' @html

function() {
  title <- "Titanic API"
  bodyIntro <-  "Welcome to the Titanic API!"
  bodyMsg <- paste("To receive a prediction on survival probability,", 
                     "submit the following variables to the <b>/titanic</b> endpoint:",
                     sep = "\n")
  varList <- list(
  pClass = "pClass (passenger's class): 1, 2, 3 (Ticket Class: 1st, 2nd, 3rd).",
  pSex = "pSex, either female or male",
  pAge = "pAge, in years.",
  pFare = "pFare, in pounds.",
  pFamily = "pFamily, other family members on board - must be integer.",
  gap = "",
  reponse = paste("Successful submission will result in a json return of",
                  " survival (response TRUE) or not (response FALSE) and",
                  " overall prediction (with a simple 50% threshold).",
                  sep = "\n"
                  )
  )
  bodyReqs <- paste(varList, collapse = "<br>")
  exampleQuery <- paste("<b>Example query:</b>",
                        ".../titanic?pClass=2&pSex=male&pAge=70&pFare=125&pFamily=0",
                        "<b> Expected response:</b>",
                        '[{"prob.FALSE":0.0479,"prob.TRUE":0.9521,"response":"TRUE"}]',
                        sep = "\n"
                        )
  
  result <- paste(
    "<html>",
    "<h1>", title, "</h1>", "<br>",
    "<body>", 
    "<p>", bodyIntro, "</p>",
    "<p>", bodyMsg, "</p>",
    "<p>", bodyReqs, "</p>",
    "<p>", exampleQuery, "</p>",
    "</body>",
    "</html>",
    collapse = "\n"
  )
  
  return(result)
}


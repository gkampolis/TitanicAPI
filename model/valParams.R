# Intro Comments ----------------------------------------------------------

# This script contains a helper function to validate the parameters passed to
# the model. It should be placed in the model folder, accompanying the actual
# model and the new data dataframe. The script is sourced (and its function
# utilised) in the "mainAPI.R"script, in the root folder.

# Created by George Kampolis.


# Validate Function -------------------------------------------------------

valParams <- function(pClass, pSex, pAge, pFare, pFamily){

  ## initialize flags for validation
  correctClass <- FALSE
  correctSex <- FALSE
  correctAge <- FALSE
  correctFare <- FALSE
  correctFamily <- FALSE
  
  ## validate pClass
  if(missing(pClass)){
    return("Parameter `pClass` is required.")
  } else if(!all.equal(as.numeric(pClass), as.integer(pClass))){
    return("Parameter `pClass` must be integer.")
  } else if(!(as.integer(pClass) %in% c(1,2,3))){
    return("Parameter `pClass` must be 1, 2 or 3.")
  } else {
    correctClass <- TRUE
  }
  
  ## validate pSex
  if(missing(pSex)){
    return("Parameter `pSex` is required.")
  } else if(!(as.character(pSex) %in% c("male", "female"))){
    return("Parameter `pSex` must be either 'male' or 'female'.")
  } else {
    correctSex <- TRUE
  }
  
  ## validate pAge
  if(missing(pAge)){
    return("Parameter `pAge` is required.")
  } else if(!is.numeric(as.numeric(pAge))){
    return("Parameter `pAge` must be numeric.")
  } else if(as.numeric(pAge) < 0 || as.numeric(pAge) > 125){
    return("Age is expected to be in range of [0,125].")
  } else {
    correctAge <- TRUE
  }
  
  ## validate pFare
  if(missing(pFare)){
    return("Paramer `pFare` is required.")
  } else if(!is.numeric(as.numeric(pFare))){
    return("Parameter `pFare` must be numeric.")
  } else if(as.numeric(pFare)<0 || as.numeric(pFare) >1000){
    return("Fare is expected to be in range of [0,1000]. Priciest actual fare was 512 pounds.")
  } else {
    correctFare <- TRUE
  }
  
  ## validate pFamily
  if(missing(pFamily)){
    return("Parameter `pFamily` is required.")
  } else if(!all.equal(as.numeric(pFamily), as.integer(pFamily))){
    return("Parameter `pFamily` must be integer.")
  } else if(as.integer(pFamily)<0 || as.integer(pFamily)>50){
    return("Family members on board is expected to be in range of [0,50].")
  } else {
    correctFamily <- TRUE
  }
  
  ## return TRUE if all parameters have been validated succesfully.
  if(correctClass && correctSex && correctAge && correctFare && correctFamily){
    return(TRUE)
  } else {
    return("Validation error occured.")
  }
}

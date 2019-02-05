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


# predict(object = titanicModel, newdata = titanic)

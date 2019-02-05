# Intro Comments ----------------------------------------------------------

# This script runs the API, as set up by `MainAPI.R`.

# Created by George Kampolis.


# Load packages -----------------------------------------------------------

library(mlr)
library(plumber)


# Run API -----------------------------------------------------------------


api <- plumb("MainAPI.R")
api$run(port=8000)

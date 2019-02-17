# Intro Comments ----------------------------------------------------------

# This script runs the API (as set up by `MainAPI.R`) locally from within R.
# This is not intended to be run inside the docker container, which is set up
# to receive the `MainAPI.R` directly - in other words, the docker container
# will automatically run (and plumb) `MainAPI.R` without needing this script.

# Created by George Kampolis.


# Load packages -----------------------------------------------------------

library(plumber)


# Run API -----------------------------------------------------------------


api <- plumb("mainAPI.R")
api$run(port=8000)

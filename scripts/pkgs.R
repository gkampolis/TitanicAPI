# Intro Comments ----------------------------------------------------------

# Helper script to load required packages for model creation. Used in
# `createModel.R`. The user receives a warning and instructions in the console
# if any packages are missing. Otherwise, the packages are loaded normally. If
# the required packages are missing, they are not installed automatically in
# case the user wants to manage their library and dependencies manually.

# Created by George Kampolis.


# Script ------------------------------------------------------------------

# Packages to be loaded:
pkgs <- c(
  "dplyr",
  "readr",
  "magrittr",
  "mlr"
)

# See which packages need to be installed:
notPresentPkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]

if (length(notPresentPkgs)) {
  # If length = 0 then this evaluates to FALSE,
  # otherwise to TRUE, for whichever value of length =/=0
  
  # Inform the user of any missing packages
  message("The following packages are needed but not installed in your system:")
  print(notPresentPkgs)
  message("You can install them now by running install.packages(notPresentPkgs)")
  message("And then re-run this script again")
} else {
  print("All required packages found, loading now...")
  # Load packages
  lapply(pkgs, require, character.only = TRUE)
  # Clean up
  rm(notPresentPkgs, pkgs)
}

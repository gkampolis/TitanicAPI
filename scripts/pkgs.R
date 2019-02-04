# Load require packages. If any are missing (see warnings in console),
# you can install them with install.packages("packageName").

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


# Intro Comments ----------------------------------------------------------

# This script creates the model to be accessed by the API later.
# It is intended to be run only once and is not needed for production.
# The resulting API and model can be tested locally from within R from
# `runAPI.R`.

# Created by George Kampolis


# Load packages -----------------------------------------------------------

# Ensure correct path:
# here::here() # if `here` is installed

# Typically, double-clicking on the .Rproj file
# should set the directory correctly.

getwd()

# Load packages.
source("scripts/pkgs.R")


# Load data ---------------------------------------------------------------

titanic <- read_csv("data/titanic.csv")

names(titanic) <- c("survived",
                    "class",
                    "name",
                    "sex",
                    "age",
                    "siblingsSpouses",
                    "parentsChildren",
                    "fare"
                  )

# Specify types when needed, read_csv assigns only characters and doubles.

titanic %<>% mutate(
  survived=as.logical(survived),
  class=as.factor(class),
  sex=as.factor(sex),
  siblingsSpouses=as.integer(siblingsSpouses),
  parentsChildren=as.integer(parentsChildren)
) 



# Create Features ---------------------------------------------------------

# Family on board
titanic %<>% mutate(familyOnBoard = siblingsSpouses + parentsChildren)

# Finalize Data Set For `mlr` ---------------------------------------------

# The names column only complicates things. For our purposes, there's no need
# to retrieve name information later, so no need to keep the name column.
# Furthermore, drop features replaced by the "familyOnBoard".

titanic %<>% select(- name, - siblingsSpouses, - parentsChildren)

# Build And Validate Model ------------------------------------------------

set.seed(2018)

## Create classficiation task

titanicTask <- makeClassifTask(data = titanic,
                               target = "survived",
                               positive = "TRUE"
                               )

## Specify Naive Bayes, set a threshold of 50%.
## The Laplace operator is used automatically.

titanicLearner <- makeLearner("classif.naiveBayes",
                              predict.type = "prob",
                              predict.threshold = 0.5)

## Naive Bayes predictions will not change unless the features
## available or the data changes. Therefore the repeated CV
## serves only as an indication of accuracy for the
## aforementioned threshold.

titanicCV <- makeResampleDesc("RepCV",
                              folds = 10,
                              reps = 20,
                              stratify = TRUE
                              )

titanicModel <- resample(titanicLearner,
                         titanicTask,
                         titanicCV,
                         list(acc, # accuracy
                              ppv, # precision
                              tpr, # recall/sensitivity
                              auc, # Area Under the Curve
                              kappa, 
                              f1,  # F1 score / F-measure
                              timetrain
                              ),
                         show.info = FALSE)

titanicModel$aggr # Show measures

# acc.test.mean       ppv.test.mean       tpr.test.mean       auc.test.mean 
# 0.7787430           0.8169804           0.5527605           0.8346610 
# kappa.test.mean     f1.test.mean        timetrain.test.mean 
# 0.5024230           0.6554890           0.0047000 

# High AUC but relativily low F1 shows we can do better with a different
# classifier. Accuracy isn't to be heavily relied upon, due to the somewhat
# unbalanced data set. However the aim of this project is not to go for best
# results but to build an API. This classifier will do for our purposes as a
# proof of concept.

## Train final model on all available data

titanicModel <- train(learner = titanicLearner,
                      task = titanicTask
                      )


# Export Model ------------------------------------------------------------


saveRDS(titanicModel, file = "model/titanicModel.rds")

## For convenience, export one row of the data set, which includes all
## information regarding factors etc.

titanicNewData <- titanic %>% select(-survived) %>% head(n = 1)

saveRDS(titanicNewData, file = "model/titanicNewData.rds")


# Clean Up ----------------------------------------------------------------

rm(titanic, titanicNewData,
   titanicCV, titanicLearner,
   titanicModel, titanicTask
   )


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
                         acc,
                         show.info = FALSE)

summary(titanicModel$measures.test$acc)

#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.6111  0.7549  0.7778  0.7802  0.8068  0.8876 

# boxplot(titanicModel$measures.test$acc) 
# the boxplot shows that the 61% accuracy is a distant outlier.

# also see:
# hist(titanicModel$measures.test$acc, breaks = "Scott")

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

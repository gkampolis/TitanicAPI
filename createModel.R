
# Intro Comments ----------------------------------------------------------

# This script creates the model to be accessed by the API later.

# Created by George Kampolis


# Load packages -----------------------------------------------------------

# Ensure correct path:

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

# specify types when needed, read_csv assigns only characters and doubles.

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

# The names column only complicates things. For our purposes, there's
# no need to retrieve name information later, so no need to keep the
# name column. Furthermore, drop age and features replaced by the
# "familyOnBoard".

titanic %<>% select(- name, - siblingsSpouses, - parentsChildren)

# Build And Validate Model ------------------------------------------------

set.seed(2018)

## Create calssficiation task

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

mean(titanicModel$measures.test$acc) # approx. 78.02%

## Train final model on all available data

titanicModel <- train(learner = titanicLearner,
                      task = titanicTask
                      )


# Export Model ------------------------------------------------------------


saveRDS(titanicModel, file = "model/titanicModel.rds")

## for convenience, export one row of the data set, which includes all
## information regarding factors etc.

titanicNewData <- titanic %>% select(-survived) %>% head(n = 1)

saveRDS(titanicNewData, file = "model/titanicNewData.rds")

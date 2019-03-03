# TitanicAPI

Pet project to explore the "Model-as-a-Service" concept via API creation.
Docker image available [here](https://hub.docker.com/r/gkampolis/titanic_api).

![](https://images.microbadger.com/badges/image/gkampolis/titanic_api.svg)

![](https://images.microbadger.com/badges/version/gkampolis/titanic_api.svg)

## Overview

Pet project for creating a simple Naïve Bayes classifier with the Titanic data set (as an example) and deploying it as an API through Docker and a container-hosting service.

This project is heavily dependent on two R packages:

* `plumber`, for creating the API with R --- see more [here](https://www.rplumber.io/)
* `mlr`, to create and use the model --- see more [here](https://mlr.mlr-org.com/)

HTTPS can be set via the platform of delivery (tested with Microsoft Azure) instead of burdening the Docker container with a server. However, it is straightforward to integrate an apache server with custom certificates. See the [security note](#A-note-regarding-security) below for more information.

## Model Creation

It is assumed that the model is created locally, by sourcing the [createModel.R](/createModel.R). The API itself needs only the the final model and one row of example data (which contains all relevant metadata), which are both stored as `.rds` files inside the `model` folder, along with the parameter validation function contained in `valParams.R`, already inside the `model` folder.

## Running the API locally (without Docker)

To test the API locally (without the Docker container), assuming that both `plumber` and  `mlr` packages are installed, all that is needed is to source the `runAPI.R` script, which will automatically plumb `mainAPI.R`.

You should be able to find the basic introductory page at http://localhost:8000.

The `/titanic` endpoint handles the actual prediction. The parameters to be passed into the model are included in the request itself for simplicity. The pattern is `/titanic?param1=value1&param2=value2`.

* Example query: http://localhost:8000/titanic?pClass=2&pSex=male&pAge=70&pFare=125&pFamily=0

* Example response: `[{"prob.FALSE":0.0479,"prob.TRUE":0.9521,"response":"TRUE"}]`

## Running the API locally (with Docker)

If you've built the Docker container (or pulled it from [here](https://hub.docker.com/r/gkampolis/titanic_api)), then you don't need to have an R installation - that's already taken care of via the container, with all the necessary packages installed.

Simply

* run locally with: `docker run --rm --user docker -p 8000:8000 titanic_api`
* and see results on http://localhost:8000/

For an example query and response, see the [previous section](#running-the-api-locally).

## Running the API from a hosted container

Simply navigate to the URL for the container. That should load the introductory page. Appending `/titanic?...` as above should result in the expected behaviour ([see the running locally section](#running-the-api-locally)), as the API maps to the endpoints directly, without any need for further manual configuration or routing.

## Data Provenance

Data was acquired from Stanford's CS109 publicly accessible page [here](http://web.stanford.edu/class/archive/cs/cs109/cs109.1166/problem12.html).

## A note regarding security

It is assumed that the container would be online behind other security measures such as user authentication and HTTPS. The container itself validates the parameters passed to it (thus avoiding the most obvious security breach) but does not implement other security features. However, such measures are easily implemented and usually already in place. Container hosting services may also offer solutions as well (as mentioned above, tested with Microsoft Azure).

If needed, HTTPS can be implemented via the container by including an apache server and the necessary certificates. For an example of such an implementation, see [T-mobile's repository](https://github.com/tmobile/r-tensorflow-api).

## Naïve-Bayes probabilities from the Titanic dataset used

### A-priori probabilities

#### Survival

|       |       |
| :---: | :---: |
| FALSE | TRUE  |
| 0.614 | 0.386 |

### Conditional probabilities (categorical features)

#### Passenger class

| Class |   1   |   2   |   3   |
| :---: | :---: | :---: | :---: |
| FALSE | 0.147 | 0.178 | 0.675 |
| TRUE  | 0.398 | 0.254 | 0.348 |

#### Sex

|  Sex  | female | male  |
| :---: | :----: | :---: |
| FALSE | 0.149  | 0.851 |
| TRUE  | 0.681  | 0.319 |

### Numerical features

Naïve-Bayes assumes Gaussian distribution for non-categorical features.

#### Age

|  Age  |  mean  | std. deviation |
| :---: | :----: | :------------: |
| FALSE | 30.139 |     13.898     |
| TRUE  | 28.408 |     14.428     |

#### Fare

| Fare  |  mean  | std. deviation |
| :---: | :----: | :------------: |
| FALSE | 22.209 |     31.484     |
| TRUE  | 48.395 |     66.597     |

#### Family members on board

While the feature is obviously an ordinal (and equally spaced by one person at a time), it has been left as a numerical to be able to predict previously unseen combinations. During input validation, it is ensured that an integer is passed to the model.

| Family |  mean | std. deviation |
|:------:|:-----:|:--------------:|
|  FALSE |  0.89 |      1.836     |
|  TRUE  | 0.939 |      1.186     |
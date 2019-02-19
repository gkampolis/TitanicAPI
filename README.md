# TitanicAPI

![](https://images.microbadger.com/badges/version/gkampolis/titanic_api.svg)
![](https://images.microbadger.com/badges/image/gkampolis/titanic_api.svg)

Pet project for creating a model with the Titanic data set and deploying it as an API through Docker.

:warning: Please note that this is a work in progress.

## Data Provenance

Data was acquired from Stanford's CS109 publicly accessible page [here](http://web.stanford.edu/class/archive/cs/cs109/cs109.1166/problem12.html).

## Naïve-Bayes probabilities

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

### Numerical variables

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

While the feature is obviously discrete/nominal, it has been left as a numerical to be able to predict previously unseen combinations.

| Family |  mean | std. deviation |
|:------:|:-----:|:--------------:|
|  FALSE |  0.89 |      1.836     |
|  TRUE  | 0.939 |      1.186     |
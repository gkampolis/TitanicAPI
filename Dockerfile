FROM trestletech/plumber
LABEL maintainer="George Kampolis <gkampolis@outlook.com>"

###########################################################
# Add mlr on top of plumber for Naive Bayes
###########################################################

# Add libxml2-dev for the `XML` package (line 26).
RUN apt-get update -qq && apt-get install -y libxml2-dev && apt-get clean -y


# Add "Depends" of mlr
RUN install2.r -e -s ParamHelpers

# Add "Imports" of mlr, this takes a while.

RUN install2.r -e -s \
BBmisc \
backports \
ggplot2 \
stringi \
checkmate \
data.table \
parallelMap \
survival \
XML

# Add mlr itself
RUN install2.r -e -s mlr

# Add e1071 required for Naive Bayes classifier
RUN install2.r -e -s e1071

###########################################################
# Copy API files
###########################################################

# Add main script to be plumbed
COPY mainAPI.R \
/home/docker/api/

# Add the contents of the `model` folder
COPY model/* \
/home/docker/api/model/

# Ensure permissions of user `docker`
RUN chown docker:docker /home/docker/*

# Designate which R script to plumb.

WORKDIR /home/docker/api

CMD ["mainAPI.R"]

###########################################################
# How To (when running locally)
###########################################################

# Run locally with: `docker run --rm --user docker -p 8000:8000 titanic_api` (defaults to `/api/mainAPI.R`)
# See results on http://localhost:8000/

# Example query:
# `http://localhost:8000/titanic?pClass=2&pSex=male&pAge=70&pFare=125&pFamily=0`
# Example response (JSON):
# [{"prob.FALSE":0.0479,"prob.TRUE":0.9521,"response":"TRUE"}]

# You can have a look around inside the image with
# `docker run -it --rm --entrypoint /bin/bash titanic_api`.

# Build with: `docker build -t titanic_api .` (Note the dot at the end)

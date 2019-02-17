FROM trestletech/plumber
LABEL maintainer="George Kampolis <gkampolis@outlook.com>"

###########################################################
# Add mlr on top of plumber
###########################################################

# Add libxml2-dev for the `XML` package (line 25).
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

##########################################################
# Copy API files
###########################################################

# Add main script
COPY mainAPI.R \
/api/

# Add the contents of the `model` folder
COPY model/* \
/api/model/

# Designate which R script to plumb.

CMD ["/api/mainAPI.R"]

# Build with: `docker build -t my_r_api .` .

# Run with: `docker run --rm -p 8000:8000 my_r_api` (defaults to `/api/MainAPI.R`)
# See results on http://localhost:8000/titanic


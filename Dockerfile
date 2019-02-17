FROM trestletech/plumber
LABEL maintainer="George Kampolis <gkampolis@outlook.com>"

###########################################################
# Add mlr on top of plumber
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

##########################################################
# Copy API files
###########################################################

# Add main script to be plumbed
COPY mainAPI.R \
/home/docker/api/

# Add the contents of the `model` folder
COPY model/* \
/home/docker/api/model/

# Ensure permissions of user `docker`
# RUN chown docker:docker /home/docker

# Designate which R script to plumb.

CMD ["/home/docker/api/mainAPI.R"]

# Build with: `docker build -t my_r_api .` (Note the dot at the end)

# Run with: `docker run --rm --user docker -p 8000:8000 my_r_api` (defaults to `/api/mainAPI.R`)
# See results on http://localhost:8000/titanic

# You can have a look around with `docker run -it --rm --entrypoint /bin/bash my_r_api`.

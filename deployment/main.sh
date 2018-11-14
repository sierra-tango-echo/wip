#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

curl <%= config.renderedurl %>deployment/cloudimage/main.sh  | /bin/bash | tee /tmp/deployment.log
curl <%= config.renderedurl %>deployment/networking/main.sh  | /bin/bash | tee /tmp/deployment.log
curl <%= config.renderedurl %>deployment/networking/networking.sh  | /bin/bash | tee /tmp/deployment.log

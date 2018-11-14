#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

curl http://stevenorledge.s3.amazonaws.com/`hostname -s`/deployment/cloudimage/main.sh / | /bin/bash | tee /tmp/deployment.log
curl http://stevenorledge.s3.amazonaws.com/`hostname -s`/deployment/networking/main.sh / | /bin/bash | tee /tmp/deployment.log
curl http://stevenorledge.s3.amazonaws.com/`hostname -s`/deployment/networking/networking.sh / | /bin/bash | tee /tmp/deployment.log

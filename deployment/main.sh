#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

info () {
  echo "INFO - $*"
}

export -f info

info "Running cloudimage"
curl <%= config.renderedurl %>deployment/cloudimage/main.sh  | /bin/bash -x 

info "Running networking" 
curl <%= config.renderedurl %>deployment/networking/main.sh  | /bin/bash -x 
curl <%= config.renderedurl %>deployment/networking/networking.sh  | /bin/bash -x 

info "Configuration complete - rebooting"
shutdown -r now

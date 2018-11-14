#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

info () {
  echo "INFO - $*"
}

export -f info

<% if (config.debug rescue false) -%>
info "Setting root password"
echo 'root:<%=config.rootpw%>' | chpasswd -e
<% end -%>

info "Running cloudimage"
curl <%= config.renderedurl %>deployment/cloudimage/main.sh  | /bin/bash -x 

info "Running networking" 
curl <%= config.renderedurl %>deployment/networking/main.sh  | /bin/bash -x 
curl <%= config.renderedurl %>deployment/networking/networking.sh  | /bin/bash -x 
curl <%= config.renderedurl %>deployment/networking/hosts.sh  | /bin/bash -x

info "Configuration complete - rebooting"
shutdown -r now

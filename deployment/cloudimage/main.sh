#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

#Undo cloudinit stuff
mkdir -p /root/.ssh
chmod 600 /root/.ssh
echo <%= config.publickey %> > /root/.ssh/authorized_keys
cat << EOF > /root/.ssh/id_rsa 
<%= config.privatekey %>
EOF
chmod 600 /root/.ssh/id_rsa
chmod 600 /root/.ssh/authorized_keys
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
#Disable cloudinit on future boots
touch /etc/cloud/cloud-init.disabled

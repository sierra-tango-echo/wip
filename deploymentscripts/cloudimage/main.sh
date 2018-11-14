#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite

#Undo cloudinit stuff
echo 'root:moose' | chpasswd
mkdir -p /root/.ssh
chmod 600 /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxOnS0K1/YsHERk1y3I2SKxT2fHM3IJzYtoTpxbRWz2zKP8Zi1P1jLBYoj86EI8GV1KpQN/gi/OHcPiJ1t9vXHlvNsJjX+JOe5/vGWAPk6xG+Pa/jHP6vUQ8FJB1X3S0UcKaPUzkILXsX+Pqs7eIjOGstVcRZ/vLYKzgvnDqSEpwjn5orpViSHFdZlozHX81iMsc5InMbsP2vRyUnSdyRhRV/5fQr/pUV2I4DRIjs+aocyfBi0EkhMP2h6OoXt0rBAJg++QVtjM9B6VoVsV4zRacrAJuWZ3x8OZa56SS7Xe04mtSizeWGAeptECfDkAdJAa8hF1p9yvw8cJfEzze7Uw== steve@zoot" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
#Disable cloudinit on future boots
touch /etc/cloud/cloud-init.disabled

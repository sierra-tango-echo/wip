VMBASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CENTOS7IMAGE=/Users/steve/iso/centos7.vdi


VMPATH=$VMBASE/<%=node.name%>

#STOP SHIT FIRST
VBoxManage controlvm <%=node.name%> poweroff
VBoxManage unregistervm <%=node.name%> --delete
rm -rf $VMPATH

#PREPILATIONS
mkdir -p $VMPATH
META=$VMPATH/meta-data
USER=$VMPATH/user-data
ISO=$VMPATH/config.iso
cat << EOF > $META
instance-id: iid-local01
dsmode: local
local-hostname: <%=node.config.networks.pri.hostname%>
hostname: <%=node.name%>
fqdn: <%=node.config.networks.pri.hostname%>
public-keys:
  - <%=config.publickey%>
EOF
cat << EOF > $USER
#cloud-config
system_info:
  default_user:
    name: test
    lock_passwd: true
    gecos: Local Administrator
    groups: [wheel, adm, systemd-journal]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
runcmd:
   - curl <%= node.config.nodescripturl %> | /bin/bash | tee /tmp/mainscript-default-output
EOF
mkisofs -o $ISO -V cidata -J $META $USER
#qemu-img convert -O vdi $CENTOS7IMAGE $VMPATH/<%=node.name%>.vdi
VBoxManage clonemedium $CENTOS7IMAGE $VMPATH/<%=node.name%>.vdi

#DOIFY
VBoxManage createvm --name <%=node.name%> --ostype RedHat_64 --register --basefolder $VMPATH
VBoxManage modifyvm <%=node.name%> --cpus 2 --memory 4096 --nic1 bridged --bridgeadapter1 en0 --vrde on --vrdeport 5001 
VBoxManage modifyvm <%=node.name%> --uart1 0x3F8 4 --uartmode1 server $VMPATH/${VMNAME}pipe
VBoxManage storagectl <%=node.name%> --name "SATA" --add sata --portcount 2

#resize the volume to something more appropriate
VBoxManage modifymedium disk $VMPATH/<%=node.name%>.vdi --resize 16000

VBoxManage storageattach <%=node.name%> --storagectl SATA --port 1 --type hdd --medium $VMPATH/<%=node.name%>.vdi
VBoxManage storageattach <%=node.name%> --storagectl SATA --port 0 --type dvddrive --medium $ISO
VBoxManage startvm <%=node.name%> --type headless

echo "VM started - connect to console with minicom -D unix#/$VMPATH/${VMNAME}pipe"

#!/bin/bash
#(c)2018 Alces Flight Ltd. HPC Consulting Build Suite
<% config.networks.each do |name, network| %>
<% if network.defined %>
cat << EOF > "${CONFIGDIR}ifcfg-<%=network.interface%>"
<% if (network.bridge rescue false) -%>
TYPE='Bridge'
STP='no'
<% elsif (network.bond rescue false) -%>
TYPE='Bond'
BONDING_OPTS='<%=network.bond.options%>'
<% elsif ! (network.interface.to_s.match(/^ib.*/).to_s.empty?) -%>
TYPE='Infiniband'
<% else -%>
TYPE='Ethernet'
<% end -%>
BOOTPROTO=none
DEFROUTE=yes
PEERDNS=no
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=<%=network.interface%>
DEVICE=<%=network.interface%>
ONBOOT=yes
IPADDR=<%=network.ip%>
NETMASK=<%=network.netmask%>
ZONE=trusted
<% if network.interface.match(/\.\d+$/)-%>
VLAN=yes
<%end-%>
<% if ! (network.gateway.to_s.empty? rescue true) -%>
GATEWAY=<%=network.gateway%>
<% end -%>
EOF
<% (network.bridge.slave_interfaces rescue []).each do |slaveinterface| -%>
cat << EOF > "${CONFIGDIR}ifcfg-<%=slaveinterface%>"
<% if (network.bond rescue false) -%>
TYPE='Bond'
BONDING_OPTS='<%=network.bond.options%>'
<% end -%>
BOOTPROTO=none
DEFROUTE=no
PEERDNS=no
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_PEERDNS=no
IPV6_PEERROUTES=no
IPV6_FAILURE_FATAL=no
ONBOOT=yes
NAME=<%=slaveinterface%>
DEVICE=<%=slaveinterface%>
BRIDGE=<%=network.bridge.interface%>
<%if slaveinterface.match(/\.\d+$/)-%>
VLAN=yes
<%end-%>
EOF
<% end -%>
<% (network.bond.slave_interfaces rescue []).each do |slaveinterface| -%>
cat << EOF > "${CONFIGDIR}ifcfg-<%=slaveinterface%>
TYPE=Bond
BOOTPROTO=none
DEFROUTE=no
PEERDNS=no
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_PEERDNS=no
IPV6_PEERROUTES=no
IPV6_FAILURE_FATAL=no
ONBOOT=yes
NAME=<%=slaveinterface%>
DEVICE=<%=slaveinterface%>
MASTER=<%=network.bond.interface%>
<%if slaveinterface.match(/\.\d+$/)-%>
VLAN=yes
<%end-%>
EOF
<% end -%>
<% end -%>
<% end -%>

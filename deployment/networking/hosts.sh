cat << EOF > /etc/hosts

<% nodes.each do |node| -%>
<% node.config.networks.each do |name, network| -%>
<% if network.defined -%>
<%= network.ip %> <%= network.hostname  %> <%= network.short_hostname -%> <%= network.primary ? node.config.networks[name].hostname.split(/\./).first : '' %>
<% end -%>
<% end %>
<% end -%>
EOF

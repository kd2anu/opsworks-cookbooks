yum_package "munin-node" do
  action :install
end

cookbook_file "/etc/munin/munin-node.conf" do
  source "munin-node.conf"
  mode "0755"
  owner "root"
  group "root"
  action :create
end

service "munin-node" do
  start_command "sudo service munin-node start" 
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

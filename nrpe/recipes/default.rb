user node[:nrpe][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:nrpe][:dir] do
  owner "icinga"
  mode "0755"
  action :create
end

remote_directory "/usr/local/nagios" do
  source "nrpe_files"
  owner "icinga"
  group "icinga"
  mode "0755"
  recursive true
  action :create_if_missing
end

execute "fix_ownership" do
  command "chown -R icinga:icinga /usr/local/nagios/*"
  user "root"
end

execute "fix_permission" do
  command "chmod -R ug+x /usr/local/nagios/*"
  user "root"
end

template "/etc/init.d/nrpe" do
  source "nrpe.erb"
  mode "0755"
  owner "root"
  group "root"
end

bash "add_service" do
  code "sudo chkconfig --add nrpe"
  not_if "chkconfig --list |grep -i nrpe"
end

service "nrpe" do
  start_command "sudo service nrpe start" 
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

package 'nrpe' do
  action :install
end

template '/etc/nagios/nrpe.cfg' do
  source 'nrpe.cfg.erb'
  owner 'root'
  group 'root'
  mode '0754'
end

remote_directory "/usr/local/nagios" do
  source "nrpe_files"
  owner "nrpe"
  group "nrpe"
  mode "0755"
  files_owner "nrpe"
  files_group "nrpe"
  files_mode "0755"
  recursive true
  action :create_if_missing
end

service "nrpe" do
  start_command "sudo service nrpe start" 
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

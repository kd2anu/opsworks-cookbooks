remote_file "/opt/logstash-forwarder-0.4.0-1.x86_64.rpm" do
  source 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder-0.4.0-1.x86_64.rpm'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

rpm_package "logstash-forwarder" do
  source '/opt/logstash-forwarder-0.4.0-1.x86_64.rpm'
  action :install
end

#execute "fix_ownership" do
#  command "chown -R icinga:icinga /usr/local/nagios/*"
#  user "root"
#end

#execute "fix_permission" do
#  command "chmod -R ug+x /usr/local/nagios/*"
#  user "root"
#end

cookbook_file "/etc/logstash-forwarder.conf" do
  source "logstash-forwarder.conf"
  mode "0755"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/pki/tls/certs/logstash-forwarder.crt" do
  source "logstash-forwarder.crt"
  mode "0755"
  owner "root"
  group "root"
  action :create
end

service "logstash-forwarder" do
  start_command "sudo service logstash-forwarder start" 
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

zone = node[:dnszone]

# Generate DB port check command if I'm dcoupon servers
if ["dcoupon.eu","dcoupon.com"].include?(zone)
  dbconn_chk_cmd="command[check_db_port]=/usr/local/nagios/libexec/check_tcp -H db.#{zone} -p 3306"
else
  dbconn_chk_cmd=""
end

package 'nrpe' do
  action :install
end

template '/etc/nagios/nrpe.cfg' do
  source 'nrpe.cfg.erb'
  owner 'root'
  group 'root'
  mode '0754'
  variables({
     :DBCONN_CHK_CMD => "#{dbconn_chk_cmd}"
  })
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

file "/etc/sudoers.d/nrpe" do
  content "nrpe ALL=(ALL) NOPASSWD:/usr/local/nagios/libexec/check_httpconn\n"
  mode "0440"
  owner "root"
  group "root"
  action :create_if_missing
end

service "nrpe" do
  start_command "sudo service nrpe start" 
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

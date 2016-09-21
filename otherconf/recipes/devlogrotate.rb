# Rotate user mails:
file '/etc/logrotate.d/mails' do
    content '/var/spool/mail/* {
        rotate 5
        dateext
        dateformat -%Y%m%d
        compress
        missingok
        notifempty
        size 2M
        copytruncate
        sharedscripts
}
'
    mode '0644'
    owner 'root'
    group 'root'
end

# Rotate war logs:
conf_dir="/opt/logrotate.d"
number=node[:opsworks][:instance][:hostname][-1,1]
webapp=node[:opsworks][:instance][:hostname].chop

directory "#{conf_dir}" do
  owner "root"
  group "root"
  mode "0744"
  action :create
end

if webapp == "api2coupons" || webapp == "api2pos" || webapp == "settlement"
  contractornumber="1"
elsif webapp == "api2campaignmgr" || webapp == "campaignmgr" || webapp == "mycoupons"
  contractornumber="2"
end

puts "== Creating logrotate config and cronjob for #{webapp} =="
# Create logrotate conf:
template "#{conf_dir}/#{webapp}.conf" do
  source "dev.conf.erb"
  owner "root"
  mode "0744"
  variables({
    :APPNAME => "#{webapp}",
    :NUMBER => "#{number}",
    :CONTRACTORNUMBER => "#{contractornumber}"
  })
end

# Create catalina.out conf:
file "#{conf_dir}/tomcat.conf" do
  content "@daily root /usr/sbin/logrotate -vf /opt/logrotate.d/tomcat.conf 2>&1 >> /var/log/logrotate.log"
  mode '0744'
  owner 'root'
  group 'root'
end

# Create cronjob:
template "/etc/crontab" do
  source "crontab.erb"
  owner "root"
  mode "0644"
  variables({:APPNAME => "#{webapp}"})
end

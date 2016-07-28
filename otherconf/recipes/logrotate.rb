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
apps=['api2POS','api2campaignmgr','campaignmgr','api2coupons','mycoupons']

template "/etc/crontab" do
  source "crontab.erb"
  owner "root"
  mode "0644"
end

directory "#{conf_dir}" do
  owner "root"
  group "root"
  mode "0744"
  action :create
end

apps.each do |eachapp|
  if eachapp == "api2coupons" || eachapp == "api2POS" || eachapp == "settlement"
    contractornumber="1"
  elsif eachapp == "api2campaignmgr" || eachapp == "campaignmgr" || eachapp == "mycoupons"
    contractornumber="2"
  end
  template "#{conf_dir}/#{eachapp}.conf" do
    source "prod.conf.erb"
    owner "root"
    mode "0744"
    variables({
      :APPNAME => "#{eachapp}",
      :NUMBER => "#{number}",
      :CONTRACTORNUMBER => "#{contractornumber}"
    })
  end
end

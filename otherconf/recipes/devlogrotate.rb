conf_dir="/opt/logrotate.d"
number=node[:opsworks][:instance][:hostname][-1,1]
apps=['api2pos','api2campaignmgr','campaignmgr','api2coupons','mycoupons']

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
  template "#{conf_dir}/#{eachapp}.conf" do
    source "dev.conf.erb"
    owner "root"
    mode "0744"
    variables({
      :APPNAME => "#{eachapp}",
      :NUMBER => "#{number}"
    })
  end
end

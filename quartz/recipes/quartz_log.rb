directory '/var/log/coupons' do
  owner 'tomcat'
  group 'tomcat'
  mode '0766'
  action :create
end

file '/var/log/coupons/api2POS.log' do
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  action :create
end

file '/var/log/coupons/quartz.log' do
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  action :create
end

file '/var/log/coupons/trazasCupones.log' do
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  action :create
end

directory '/var/log/coupons' do
  owner 'root'
  group 'root'
  mode '0766'
  action :create
end

file '/var/log/coupons/api2POS.log' do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

file '/var/log/coupons/quartz.log' do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

file '/var/log/coupons/trazasCupones.log' do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

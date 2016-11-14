template "/usr/bin/online" do
  source "online.erb"
  owner "root"
  mode "0755"
end

template "/usr/bin/offline" do
  source "online.erb"
  owner "root"
  mode "0755"
end

execute "flushram" do
  command '/bin/echo "alias flushram=\'free -m && sync && echo 3 > /proc/sys/vm/drop_caches && free -m\'" >> ~/.bashrc'
  user "root"
  group "root"
  not_if 'grep "flushram" ~/.bashrc'
end

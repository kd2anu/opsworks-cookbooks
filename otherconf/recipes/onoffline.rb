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

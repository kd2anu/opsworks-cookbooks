cookbook_file "/opt/assigndomain.py" do
  source "assigndomain.py"
  mode 0500
end

params = node[:opsworks][:instance][:hostname]+" "+node[:dnszone]+" "+node[:access_key]+" "+node[:secret_key]
#puts "#{params}"

execute "assigndomain" do
  command "/opt/assigndomain.py #{params}"
  user "root"
end

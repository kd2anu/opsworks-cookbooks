cookbook_file "/root/assigndomain.py" do
  source "assigndomain.py"
  mode 0500
end

params = "dev"+node[:opsworks][:instance][:hostname].chop+" "+node[:dnszone]+" "+node[:access_key]+" "+node[:secret_key]
#puts "#{params}"

execute "assigndomain" do
  command "/root/assigndomain.py #{params}"
  user "root"
end

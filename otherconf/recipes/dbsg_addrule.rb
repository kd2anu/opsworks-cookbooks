cookbook_file "/opt/dbsg_addrule.py" do
  source "dbsg_addrule.py"
  mode 0500
end

params = node[:dnszone]+" "+node[:access_key]+" "+node[:secret_key]

execute "dbsg_addrule" do
  command "/opt/dbsg_addrule.py #{params}"
  user "root"
end

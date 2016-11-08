install_dir=node['tomcat']['install_dir']
conf_dir="#{install_dir}/conf"

cookbook_file "#{conf_dir}/server.xml" do
  source "server.xml"
  mode '0600'
  group 'root'
  owner 'root'
  action :create
end

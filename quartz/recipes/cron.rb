application = node[:opsworks][:instance][:hostname].chop

if application == "api2campaign"
  template 'quartz.properties.erb' do
    path ::File.join(node['tomcat']['install_dir'],'webapps',"#{application}",'/WEB-INF/classes/quartz.properties')
    source 'quartz.properties.erb'
    owner 'deploy'
    group 'apache'
    mode 0640
    variables({
       :minute => Integer(node[:opsworks][:instance][:hostname][-1,1])*5
    })
  end
end

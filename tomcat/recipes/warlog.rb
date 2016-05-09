include_recipe 'tomcat::service'

node[:deploy].each do |application, deploy|
  if application != node[:opsworks][:instance][:hostname].chop
    puts "=== Skip generating WAR log file for undesired module: #{application} ==="
    next
  end

  if application != "root"
    puts "=== Skip generating WAR log file for undesired module: #{application} ==="
    next
  end

  if application != "root"
    template "logging.properties for #{application}" do
      path ::File.join(node['tomcat']['webapps_base_dir'], "#{application}", 'WEB-INF', 'classes', 'logging.properties')
      source 'logging.properties.erb'
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode 0644
      backup false
      notifies :restart, resources(:service => 'tomcat')
    end
  end
end

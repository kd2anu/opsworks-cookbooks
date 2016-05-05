include_recipe 'tomcat::service'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java-undeploy application #{application} as it is not a Java app")
    next
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  if webapp_name == node[:opsworks][:instance][:hostname] || webapp_name == 'ROOT'
    puts "Skip undeploying desired module: #{webapp_name}"
    next
  end

  # webapp_dir is pointing to links, not the actual app dir
  webapp_dir = ::File.join(node['tomcat']['webapps_base_dir'], webapp_name)

  link webapp_dir do
    action :delete
  end

  # this is the actual app dir
  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if { ::File.exists?("#{deploy[:deploy_to]}") }
  end

  # delete webapp context files
  context_name = application

  file "context file for #{application} (context name: #{context_name})" do
    path ::File.join(node['tomcat']['catalina_base_dir'], 'Catalina', 'localhost', "#{context_name}.xml")
    action :delete
    only_if { node['datasources'][context_name] }
  end

  # restart tomcat
  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    notifies :restart, resources(:service => 'tomcat')
  end

end

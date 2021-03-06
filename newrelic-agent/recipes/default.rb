install_dir=node['tomcat']['install_dir']
tomcat_user=node['tomcat']['tomcat_user']
tomcat_group=node['tomcat']['tomcat_group']
application = node[:opsworks][:instance][:hostname].chop
country = node[:opsworks][:stack][:name][-2,2]

cookbook_file "#{install_dir}/newrelic-java-3.31.0.zip" do
  source "newrelic-java-3.31.0.zip"
  mode 0644
end

execute 'unzip_package' do
  command "/usr/bin/unzip #{install_dir}/newrelic-java-3.31.0.zip -d #{install_dir}"
  cwd '/root'
  only_if { File.exists?("#{install_dir}/newrelic-java-3.31.0.zip") }
end

template "#{install_dir}/newrelic/newrelic.yml" do
  source 'newrelic.yml.erb'
  owner 'deploy'
  group 'apache'
  mode 0640
  variables({
     :appname => "#{application}_#{country}"
  })
  only_if { File.exists?("/usr/share/tomcat7/newrelic/newrelic.yml") }
end

execute 'install_newrelic_agent' do
  command "/usr/bin/java -jar newrelic.jar install"
  cwd "#{install_dir}/newrelic/"
  only_if { File.directory?("/usr/share/tomcat7/newrelic") }
end

service 'tomcat7' do
  action :restart
  only_if {File.exists?("/etc/init.d/tomcat7")}
  only_if %Q{/usr/bin/yum list installed tomcat-native 2>&1 >> /dev/null && true || false}
end

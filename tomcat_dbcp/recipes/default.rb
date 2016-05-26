remote_file "/opt/apache-tomcat-7.0.67.zip" do
  source 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.zip'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'unzip_tomcat' do
  user 'root'
  group 'root'
  cwd '/opt'
  action :run
  command 'unzip -u /opt/apache-tomcat-7.0.67.zip -d /opt'
#  not_if do ::File.exists?('/opt/jaxws-ri-2.2.10.zip') end
end

execute 'move_jar' do
  user 'root'
  group 'root'
  cwd '/opt/apache-tomcat-7.0.67/lib'
  action :run
  command "cp /opt/apache-tomcat-7.0.67/lib/tomcat-dbcp.jar /usr/share/java/tomcat7"
end

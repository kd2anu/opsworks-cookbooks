remote_file "/opt/jaxws-ri-2.2.10.zip" do
  source 'http://repo.maven.apache.org/maven2/com/sun/xml/ws/jaxws-ri/2.2.10/jaxws-ri-2.2.10.zip'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'unzip_jaxws' do
  user 'root'
  group 'root'
  cwd '/opt'
  action :run
  command 'unzip -u /opt/jaxws-ri-2.2.10.zip -d /opt'
#  not_if do ::File.exists?('/opt/jaxws-ri-2.2.10.zip') end
end

execute 'move_jar' do
  user 'root'
  group 'root'
  cwd '/opt/jaxws-ri/lib'
  action :run
  command "cp /opt/jaxws-ri/lib/*.jar /usr/share/java/tomcat7"
end

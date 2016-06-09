direct_download_version=node['tomcat']['direct_download_version']
direct_download_url= "http://archive.apache.org/dist/tomcat/tomcat-7/v"+"#{direct_download_version}"+"/bin/apache-tomcat-#{direct_download_version}.tar.gz";

install_dir=node['tomcat']['install_dir']
webapps_base_dir="#{install_dir}/webapps"

tomcat_user=node['tomcat']['tomcat_user']
tomcat_group=node['tomcat']['tomcat_group']

script "Download Apache Tomcat #{direct_download_version}" do
  interpreter "bash"
  user "#{tomcat_user}"
  cwd "/opt"
  code <<-EOH
  wget "#{direct_download_url}" -O "/opt/apache-tomcat-#{direct_download_version}.tar.gz"
  EOH
end

execute "Unzip Apache Tomcat #{direct_download_version}" do
  user "#{tomcat_user}"
  group "#{tomcat_group}"
  cwd "#{install_dir}"
  command "mkdir -p #{install_dir}; tar zxf /opt/apache-tomcat-#{direct_download_version}.tar.gz -C #{install_dir} --strip-components=1"
  action :run
end

template "#{install_dir}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner "#{tomcat_user}"
  mode "0755"
end

template "/etc/rc.d/init.d/tomcat7" do
  source "tomcat7.erb"
  owner "#{tomcat_user}"
  mode "0755"
end

execute "Add tomcat7 to chkconfig" do
  user "root"
  group "root"
  command "chkconfig --add tomcat7"
  action :run
end

ruby_block 'remove all default webapp' do
  block do
    Dir.foreach(webapps_base_dir) do |f|
      fn = File.join(webapps_base_dir, f)
      FileUtils.rm_rf(fn) if f != '.' && f != '..'
    end
  end
end

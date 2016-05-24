bash 'install_gpg_key' do
  code '/bin/rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch'
  user 'root'
end

template '/etc/yum.repos.d/beats.repo' do
  source 'beats.repo.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

yum_package 'filebeat.x86_64' do
  action :install
end

template '/etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'verbose_output' do
  code '/bin/sed -i "27s/\-c/\-v \-c/" /etc/init.d/filebeat'
  user 'root'
end

template '/etc/pki/tls/certs/beats.crt' do
  source 'beats.crt.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'add_chkconfig' do
  code '/sbin/chkconfig --add filebeat'
  user 'root'
end

service 'filebeat' do
  action [:enable, :start]
end

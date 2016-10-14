yum_package 'tomcat-native' do
  flush_cache [ :after ]
  action :install
end

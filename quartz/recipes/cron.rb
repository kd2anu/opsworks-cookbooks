application = node[:opsworks][:instance][:hostname].chop

template 'quartz_jobs.xml' do
  path ::File.join('/srv/www/',"#{application}",'/current/WEB-INF/classes/quartz_jobs.xml')
  source 'quartz_jobs.xml.erb'
  owner 'deploy'
  group 'apache'
  mode 0640
  variables({
     :minute => node[:opsworks][:instance][:hostname][-1,1]
  })
end
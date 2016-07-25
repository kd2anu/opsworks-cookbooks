directory '/srv/www/my_app/public/' do
  owner 'deploy'
  group 'www-data'
  recursive true
end

directory '/etc/apache2/sites-available/my_app.conf.d/' do
    owner 'root'
    group 'root'
    mode 0644
    recursive true
end

template 'myapp_vhost' do
    path  '/etc/apache2/sites-available/my_app.conf'
    owner 'root'
    group 'root'
    mode 0644
end

link "/etc/apache2/sites-enabled/my_app.conf" do
  to "/etc/apache2/sites-available/my_app.conf"
end

include_recipe 'nginx::default'
include_recipe 'nginx::http_realip_module'
include_recipe 'nginx::http_ssl_module'

nginx_site do
  name 'test_site'
  template 'site.conf.erb'
  action :enable
end

directory node['nginx']['default_root'] do
  recursive true
end

template "#{node['nginx']['default_root']}/index.html" do
  source 'index.html.erb'
end

cookbook_file '/etc/nginx/privateKey.key' do
  source 'privateKey.key'
end

cookbook_file '/etc/nginx/certificate.crt' do
  source 'certificate.crt'
end

# nginx restart requested by code challenge
cron 'restart_nginx' do
  action :create
  minute '0'
  hour '0'
  command 'service nginx restart'
end
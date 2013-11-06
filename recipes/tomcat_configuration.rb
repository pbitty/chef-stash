settings = Stash.settings(node)
stash_version = Chef::Version.new(node['stash']['version'])

template "#{node['stash']['install_path']}/stash/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner  node['stash']['user']
  mode   '0755'
  notifies :restart, 'service[stash]', :delayed
end

template "#{node['stash']['install_path']}/stash/conf/server.xml" do
  source 'server.xml.erb'
  owner  node['stash']['user']
  mode   '0640'
  variables :tomcat => settings['tomcat'], :apache => settings['apache2'], :is_tomcat7 => (stash_version.major > 1)
  notifies :restart, 'service[stash]', :delayed
end

template "#{node['stash']['install_path']}/stash/conf/web.xml" do
  if stash_version.major == 1
    source 'web.xml.erb'
  else
    source 'web-tomcat7.xml.erb'
  end
  owner  node['stash']['user']
  mode   '0644'
  notifies :restart, 'service[stash]', :delayed
end

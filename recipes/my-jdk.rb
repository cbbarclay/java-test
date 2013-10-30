source_url = "https://s3.amazonaws.com/chrisb/server-jre-7u45-linux-x64.gz"
jdk_uri = ::URI.parse(source_url)
jdk_filename = ::File.basename(jdk_uri.path)

remote_file "#{Chef::Config[:file_cache_path]}/#{jdk_filename}" do
  source source_url
  mode 00755
  notifies :run, "execute[install-custom-java]", :immediately
end

execute "install-custom-java" do
  cwd Chef::Config[:file_cache_path]
  command "./#{jdk_filename} -f ./installer.properties -i silent"
  creates "#{node['java']['java_home']}/jre/bin/java"
end

include_recipe "java::set_java_home"

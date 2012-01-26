package "sphinxsearch"

service "searchd" do
  start_command "/usr/sbin/invoke-rc.d sphinxsearch start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d sphinxsearch stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d sphinxsearch restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d sphinxsearch reload && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart, :reload ] }
  )
  action :nothing
end


directory " /var/lib/sphinxsearch/data" do
  mode 0755
  action :create
  recursive true
end

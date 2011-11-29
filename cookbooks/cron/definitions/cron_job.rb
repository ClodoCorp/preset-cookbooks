define :cron_job, :type => "", :name => "", :action => "", :vars => [] do
  if params[:action] == "create"
    template "/etc/cron.#{params[:type]}/#{params[:name]}" do
      source "jobs/#{params[:name]}.erb"
      if params.has_key?("vars")
        variables ( "#{params[:vars]}" )
      end
      mode 0644
      owner "root"
      group "root"
    end
  end
end


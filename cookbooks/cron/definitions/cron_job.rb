define :cron_job, :type => "", :name => "", :action => "", :vars => [] do
  if params[:action] == "create"
    template "/etc/cron.#{params[:type]}/#{params[:name]}" do
      source "jobs/#{params[:name]}.erb"
      if params[:cookbook]
        cookbook params[:cookbook]
      end
      if params.has_key?("vars")
        variables ( "#{params[:vars]}" )
      end
      mode 0755
      owner "root"
      group "root"
      backup 0
    end
  end
end


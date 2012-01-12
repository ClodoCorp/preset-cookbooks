define :hosts do
  include_recipe "hosts"
  if params[:action] == "add"
    if params[:name] != "" && params[:host] != ""
      execute "add ip #{params[:name]}" do
        command "echo '#{params[:name]} #{params[:host]}' >> /etc/hosts"
      end
    end
  end
end

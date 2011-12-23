define :mirror_file do
  remote_file "mirror #{params[:name]}" do
    path "#{params[:path]}"
    source "http://pkgs.clodo.ru/presets/#{params[:name]}"
    mode "#{params[:mode]}"
    action :nothing
  end

  remote_file "origin #{params[:name]}" do
    path "#{params[:path]}"
    source "#{params[:source]}"
    mode "#{params[:mode]}"
    action :nothing
  end

  ruby_block "check" do
    block do
      begin
        n = Net::HTTP.new("pkgs.clodo.ru", "80")
        n.request_head("/presets/#{params[:name]}").value
	notifies :create, resources(:remote_file => "mirror #{params[:name]}"), :immediately
      rescue Net::HTTPServerException
        notifies :create, resources(:remote_file => "origin #{params[:name]}"), :immediately
      end
      action :create
    end
  end
end

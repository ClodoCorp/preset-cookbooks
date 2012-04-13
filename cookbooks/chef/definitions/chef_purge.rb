define :chef_purge, :clean => true do

  if params[:clean] == true
    params[:packages].each do |pkg|
      package "#{pkg}" do
        action :purge
        options "--force-yes"
      end
    end

#    params[:commands].each do |cmd|
#      execute "run #{cmd}" do
#        command "#{cmd}"
#      end
#    end


    directory "/var/chef-solo" do
      action :delete
      recursive true
    end

  end

end


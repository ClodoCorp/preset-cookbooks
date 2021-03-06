#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "cron" do
  action :upgrade
end

cron_job do
  type "daily"
  name "purge"
  action "create"
end

node[:cron][:daily].each do |job|
  template "#{node[:nginx][:dir]}/sites-available/#{params[:name]}" do
    source "sites/#{params[:name]}.erb"
      if params.has_key?("vars")
        variables ( "#{params[:vars]}" )
      end
      mode 0644
      owner "root"
      group "root"
    end

end

#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2008-2013, Opscode, Inc.
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

prefix = node['authorization']['sudo']['prefix']

package 'sudo' do
  not_if { node['platform'] == 'mac_os_x' }
end

if node['authorization']['sudo']['include_sudoers_d']
  directory "#{prefix}/sudoers.d" do
    mode    '0755'
    owner   'root'
    group value_for_platform(
                                "mac_os_x" => { "default" => "wheel" },
                                "freebsd" => { "default" => "wheel" },
                                "default" => "root"
                              )
  end

  cookbook_file "#{prefix}/sudoers.d/README" do
    source  'README'
    mode    '0440'
    owner   'root'
    group value_for_platform(
                                "mac_os_x" => { "default" => "wheel" },
                                "freebsd" => { "default" => "wheel" },
                                "default" => "root"
                              )
  end
end

template "#{prefix}/sudoers" do
  source 'sudoers.erb'
  mode   '0440'
  owner  'root'
  group value_for_platform(
                                "mac_os_x" => { "default" => "wheel" },
                                "freebsd" => { "default" => "wheel" },
                                "default" => "root"
                              )
  variables(
    :sudoers_groups    => node['authorization']['sudo']['groups'],
    :sudoers_users     => node['authorization']['sudo']['users'],
    :passwordless      => node['authorization']['sudo']['passwordless'],
    :include_sudoers_d => node['authorization']['sudo']['include_sudoers_d'],
    :agent_forwarding  => node['authorization']['sudo']['agent_forwarding'],
    :sudoers_defaults  => node['authorization']['sudo']['sudoers_defaults']
  )
end

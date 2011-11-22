#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2011, Vasiliy Tolstov <v.tolstov@selfip.ru>, Clodo.
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

default['mysql']['memory_max'] = "256M"
default['mysql']['memory_min'] = "128M"
default['mysql']['data_dir']                   = "/var/lib/mysql"

case node["platform"]
when "centos", "redhat", "fedora", "suse"
  set['mysql']['conf_dir']                    = '/etc'
  set['mysql']['socket']                      = "/var/lib/mysql/mysql.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 1
else
  set['mysql']['conf_dir']                    = '/etc/mysql'
  set['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 0
end

default['mysql']['allow_remote_root']               = false
default['mysql']['tunable']['back_log']             = "128"
default['mysql']['tunable']['key_buffer']           = "56M"
default['mysql']['tunable']['max_allowed_packet']   = "16M"
default['mysql']['tunable']['max_connections']      = "50"
default['mysql']['tunable']['max_heap_table_size']  = "32M"
default['mysql']['tunable']['myisam_recover']       = "BACKUP"

#timeouts
default['mysql']['tunable']['net_read_timeout']     = "30"
default['mysql']['tunable']['net_write_timeout']    = "30"
default['mysql']['tunable']['wait_timeout']         = "180"

#table caches
default['mysql']['tunable']['table_cache']          = "64"
default['mysql']['tunable']['table_open_cache']     = "64"

#thread caches
default['mysql']['tunable']['thread_cache']         = "128"
default['mysql']['tunable']['thread_cache_size']    = 8
default['mysql']['tunable']['thread_concurrency']   = 10
default['mysql']['tunable']['thread_stack']         = "256K"

#query caches
default['mysql']['tunable']['query_cache_limit']    = "1M"
default['mysql']['tunable']['query_cache_size']     = "16M"

default['mysql']['tunable']['log_slow_queries']     = "/var/log/mysql/slow.log"
default['mysql']['tunable']['long_query_time']      = 2

default['mysql']['tunable']['expire_logs_days']     = 10
default['mysql']['tunable']['max_binlog_size']      = "100M"
default['mysql']['tunable']['innodb_buffer_pool_size']  = "256M"
default['cl_mysql']['symbolic_links'] 		= 0
default['cl_mysql']['allow_remote_root']	= 0
default['cl_mysql']['character_set_server']	= "utf8"
default['cl_mysql']['default_storage_engine']	= "InnoDB"
default['cl_mysql']['tunable']['concurrent_insert'] 		= 1
default['cl_mysql']['tunable']['query_cache_limit']		= "1M"
default['cl_mysql']['tunable']['query_cache_size']		= "16M"
default['cl_mysql']['tunable']['query_cache_type']		= 1
default['cl_mysql']['tunable']['table_open_cache']		= 256
default['cl_mysql']['tunable']['table_definition_cache']	= 256
default['cl_mysql']['tunable']['thread_cache_size']		= 128
default['cl_mysql']['tunable']['max_allowed_packet']		= "16M"
default['cl_mysql']['tunable']['max_heap_table_size']		= "128M"
default['cl_mysql']['tunable']['tmp_table_size']		= "128M"
default['cl_mysql']['tunable']['myisam_sort_buffer_size']	= "128M"
default['cl_mysql']['tunable']['net_read_timeout']		= 30
default['cl_mysql']['tunable']['net_write_timeout']		= 30
default['cl_mysql']['tunable']['back_log']			= 128
default['cl_mysql']['tunable']['wait_timeout']			= 180
default['cl_mysql']['tunable']['myisam_recover']		= "BACKUP"
default['cl_mysql']['tunable']['long_query_time']		= 2
default['cl_mysql']['tunable']['innodb_log_file_size'] 		= "128M"
default['cl_mysql']['tunable']['innodb_thread_concurrency']		= 8
default['cl_mysql']['tunable']['innodb_flush_log_at_trx_commit']	= 2
default['cl_mysql']['tunable']['innodb_lock_wait_timeout']		= 150
default['cl_mysql']['tunable']['innodb_open_files']			= 300
default['cl_mysql']['mysqldump']['max_allowed_packet']			= "16M"
default['cl_mysql']['myisamchk']['key_buffer_size']			= "256M"
default['cl_mysql']['myisamchk']['sort_buffer_size']			= "256M"
default['cl_mysql']['myisamchk']['read_buffer']			= "2M"
default['cl_mysql']['myisamchk']['write_buffer']			= "2M"


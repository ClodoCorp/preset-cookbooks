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
default['mysql']['mysqld']['data_dir']                   = "/var/lib/mysql"
default['mysql']['mysqld']['confd_dir']                  = '/etc/mysql/conf.d/'

case node["platform"]
when "centos", "redhat", "fedora", "suse"
  set['mysql']['mysqld']['conf_dir']                    = '/etc'
  set['mysql']['mysqld']['confd_dir']			= '/etc/mysql/conf.d/'
  set['mysql']['mysqld']['socket']                      = "/var/lib/mysql/mysql.sock"
  set['mysql']['mysqld']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['mysqld']['old_passwords']               = 1
else
  set['mysql']['mysqld']['conf_dir']                    = '/etc/mysql'
  set['mysql']['mysqld']['confd_dir']                   = '/etc/mysql/conf.d/'
  set['mysql']['mysqld']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['mysqld']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['mysqld']['old_passwords']               = 0
end

default['mysql']['mysqld']['back_log']             = "128"
#default['mysql']['mysqld']['key_buffer']           = "56M"
default['mysql']['mysqld']['max_allowed_packet']   = "16M"
#default['mysql']['mysqld']['max_connections']      = "50"
#default['mysql']['mysqld']['max_heap_table_size']  = "32M"

default['mysql']['mysqld']['myisam_recover']       = "BACKUP"
default['mysql']['mysqld']['myisam_sort_buffer_size']   = "64M"

#timeouts
default['mysql']['mysqld']['net_read_timeout']     = "30"
default['mysql']['mysqld']['net_write_timeout']    = "30"
default['mysql']['mysqld']['wait_timeout']         = "180"

#table caches
#default['mysql']['mysqld']['table_cache']          = "64"
#default['mysql']['mysqld']['table_open_cache']     = "64"
#default['mysql']['mysqld']['table_definition_cache']    = 64

#thread caches
#default['mysql']['mysqld']['thread_cache']         = "128"
#default['mysql']['mysqld']['thread_cache_size']    = 128
default['mysql']['mysqld']['thread_concurrency']   = 10
#default['mysql']['mysqld']['thread_stack']         = "256K"

#query caches
#default['mysql']['mysqld']['query_cache_limit']    = "1M"
#default['mysql']['mysqld']['query_cache_size']     = "16M"
default['mysql']['mysqld']['query_cache_type']          = 1

#default['mysql']['mysqld']['join_buffer_size'] 		= "8M"
#default['mysql']['mysqld']['sort_buffer_size']		= "2M"
#default['mysql']['mysqld']['read_buffer_size']		= "2M"
#default['mysql']['mysqld']['read_rnd_buffer_size']	= "8M"
#default['mysql']['mysqld']['key_buffer_size']		= "64M"
default['mysql']['mysqld']['myisam_sort_buffer_size']	= "64M"

default['mysql']['mysqld']['log_slow_queries']     = "/var/log/mysql/slow.log"
default['mysql']['mysqld']['long_query_time']      = 2

#innodb
#default['mysql']['mysqld']['innodb_log_buffer_size']           = "32M"
#default['mysql']['mysqld']['innodb_additional_mem_pool_size']   = "2M"
#default['mysql']['mysqld']['innodb_log_file_size']              = "128M"
#default['mysql']['mysqld']['innodb_thread_concurrency']         = 8
default['mysql']['mysqld']['innodb_flush_log_at_trx_commit']    = 2
default['mysql']['mysqld']['innodb_lock_wait_timeout']          = 150
default['mysql']['mysqld']['innodb_open_files']                 = 300
#default['mysql']['mysqld']['innodb_buffer_pool_size']  = "128M"

default['mysql']['mysqld']['expire_logs_days']     = 10
default['mysql']['mysqld']['max_binlog_size']      = "100M"
default['mysql']['mysqld']['symbolic_links'] 		= 0
default['mysql']['mysqld']['allow_remote_root']	= 0
default['mysql']['mysqld']['character_set_server']	= "utf8"
default['mysql']['mysqld']['default_storage_engine']	= "MYISAM"
default['mysql']['mysqld']['concurrent_insert'] 		= 1
#default['mysql']['mysqld']['tmp_table_size']		= "64M"

#mysqldump
default['mysql']['mysqldump']['max_allowed_packet']			= "16M"

#myisamcheck
default['mysql']['myisamchk']['key_buffer_size']			= "64M"
default['mysql']['myisamchk']['sort_buffer_size']			= "64M"
default['mysql']['myisamchk']['read_buffer']			= "2M"
default['mysql']['myisamchk']['write_buffer']			= "2M"


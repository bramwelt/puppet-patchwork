# == Class: patchwork::database::mysql
#
# Exports the patchwork database to be collect by a mysql server.
# Optionally configures and installs a local mysql server.
#
# === Authors
#
# Trevor Bramwell <tbramwell@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Trevor Bramwell
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class patchwork::database::mysql (
    $database        = 'patchwork',
    $host            = '127.0.0.1',
    $port            = 3306,
    $username        = 'patchwork',
    $password        = 'patchwork',
    $manage_database = true,
    $database_tag    = 'mysql-database',
) {

  if ($manage_database) {
    class { '::mysql::server': }
    class { '::mysql::bindings':
      python_enable => true,
    }
  }

  @@mysql::db { "${database}_${::fqdn}":
    user     => $username,
    password => $password,
    dbname   => $database,
    host     => $::ipaddress,
    tag      => $database_tag,
  }
}

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
class patchwork::database::mysql {
  include patchwork

  validate_bool($patchwork::collect_exported)
  if ($patchwork::collect_exported) {
    @@mysql::db { "patchwork_${::fqdn}":
      user     => $patchwork::database_user,
      password => $patchwork::database_pass,
      dbname   => $patchwork::database_name,
      host     => $patchwork::database_host,
      tag      => $patchwork::database_tag,
      before   => Exec['load defaults'],
      notify   => Exec['syncdb'],
    }
  } else {
    mysql::db { 'patchwork':
      ensure   => 'present',
      user     => $patchwork::database_user,
      password => $patchwork::database_pass,
      host     => $patchwork::database_host,
      before   => Exec['load defaults'],
      notify   => Exec['syncdb'],
    }
  }

  exec { 'syncdb':
    command => "${patchwork::virtualenv_dir}/bin/python manage.py syncdb --noinput",
    user    => $patchwork::user,
    group   => $patchwork::group,
    cwd     => $patchwork::install_dir,
    require => Python::Requirements[$patchwork::requirements],
    notify  => Exec['load defaults'],
  }

  exec { 'load defaults':
    command     => "${patchwork::virtualenv_dir}/bin/python manage.py loaddata default_tags default_states",
    user        => $patchwork::user,
    group       => $patchwork::group,
    cwd         => $patchwork::install_dir,
    noop        => true,
    refreshonly => true,
    require     => [
      Exec['syncdb'],
      Python::Requirements[$patchwork::requirements],
    ],
  }

}

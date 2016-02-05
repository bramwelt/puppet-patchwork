# == Class: patchwork::params
#
# Parameter definition for patchwork
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
class patchwork::params {
  $install_dir      = '/opt/patchwork'
  $virtualenv_dir   = '/opt/patchwork/venv'
  $requirements     = '/opt/patchwork/docs/requirements-prod.txt'
  $version          = 'master'
  $user             = 'patchwork'
  $group            = 'patchwork'
  $source_repo      = 'git://github.com/getpatchwork/patchwork'
  $database_name    = 'patchwork'
  $database_host    = 'localhost'
  $database_user    = 'patchwork'
  $database_pass    = 'patchwork'
  $database_tag     = 'mysql-patchwork'
  $uwsgi_options    = {
    virtualenv  => '/opt/patchwork/venv',
    chdir       => '/opt/patchwork',
    static-map  => '/static=/opt/patchwork/static',
    logto       => '/var/log/patchwork/uwsgi.log',
    master      => true,
    http-socket => ':9000',
    wsgi-file   => 'patchwork.wsgi',
    processes   => 4,
    threads     => 2,
  }
  $collect_exported = false
  $cron_minutes     = 10
}

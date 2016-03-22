# == Class: patchwork
#
# Manages the installation and configuration of Patchwork
#
#  http://jk.ozlabs.org/projects/patchwork/
#  https://patchwork.readthedocs.org/en/latest/
#
# === Parameters
#
# [*location*]
#   Location patchwork should be cloned to.
#
#   Default: '/opt/patchwork'
#
# [*virtualenv_path*]
#   File path to where the virtualenv should live.
#
#   Default: '/opt/patchwork/venv'
#
# [*version*]
#   Version of patchwork that should be installed.
#   If 'latest' is specified, the installation will track the tip of the
#   patchwork 'master' branch, otherwise the repo will be ensured
#   'present' overwriting any local changes that take place.
#
#   Default: 'master'
#
# [*source_repo*]
#   The source repo for installing patchwork. As patchwork is not
#   currently packaged, it must be installed from source.
#
#   Default: git://github.com/getpatchwork/patchwork
#
# [*manage_git*]
#   Flag for installing git.
#
#   Default: true
#
# [*manage_python*]
#   Flag for installing python.
#
#   Default: true
#
# [*manage_database*]
#   Flag for installing a local mysql server.
#
#   Default: true
#
# [*uwsgi_overrides*]
#   Items in the hash will replace the defaults listed in
#   `uwsgi_options` of the params class.
#
#   Default: {}
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
class patchwork (
  $install_dir       = $patchwork::params::install_dir,
  $virtualenv_dir    = $patchwork::params::virtualenv_dir,
  $version           = $patchwork::params::version,
  $user              = $patchwork::params::user,
  $group             = $patchwork::params::group,
  $source_repo       = $patchwork::params::source_repo,
  $manage_git        = true,
  $manage_python     = true,
  $manage_database   = true,
  # Database settings
  $database_name     = $patchwork::params::database_name,
  $database_host     = $patchwork::params::database_host,
  $database_user     = $patchwork::params::database_user,
  $database_pass     = $patchwork::params::database_pass,
  $database_tag      = $patchwork::params::database_tag,
  $uwsgi_overrides   = {},
  $collect_exported  = $patchwork::params::collect_exported,
  $cron_minutes      = $patchwork::params::cron_minutes,
) inherits patchwork::params {

  validate_absolute_path($install_dir)
  validate_absolute_path($virtualenv_dir)
  validate_string($version)
  validate_string($user)
  validate_string($group)
  validate_string($source_repo)
  validate_bool($manage_git)
  validate_bool($manage_python)
  validate_bool($manage_database)
  validate_string($database_name)
  validate_string($database_host)
  validate_string($database_user)
  validate_string($database_pass)
  validate_string($database_tag)
  validate_hash($uwsgi_overrides)
  validate_bool($collect_exported)
  validate_integer($cron_minutes, 59, 0)

  $uwsgi_config = merge($patchwork::params::uwsgi_options, $uwsgi_overrides)

  anchor { 'patchwork:begin': }
  anchor { 'patchwork:end': }

  include 'patchwork::install'
  include 'patchwork::database::mysql'
  include 'patchwork::config'
  include 'patchwork::uwsgi'
  include 'patchwork::cron'

  Anchor['patchwork:begin'] ->
    Class['patchwork::install'] ->
    Class['patchwork::config'] ->
    Class['patchwork::database::mysql'] ->
    Class['patchwork::uwsgi'] ->
    Class['patchwork::cron'] ->
  Anchor['patchwork:end']

}

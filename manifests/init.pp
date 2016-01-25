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
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
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
  $source_repo       = $patchwork::params::source_repo,
  $user              = $patchwork::user,
  $group             = $patchwork::group,
  $git_manage        = true,
  $python_manage     = true,
  $database_manage   = true,
  # Database settings
  $database_name     = $patchwork::params::database_name,
  $database_host     = $patchwork::params::database_host,
  $database_user     = $patchwork::params::database_user,
  $database_pass     = $patchwork::params::database_pass,
  $database_tag      = $patchwork::params::database_tag,
  $collect_exported  = $patchwork::params::collect_exported,
) inherits patchwork::params {

  validate_string($install_dir)
  validate_string($virtualenv_dir)
  validate_string($version)
  validate_string($source_repo)

  validate_bool($git_manage)
  validate_bool($python_manage)
  validate_bool($database_manage)

  anchor { 'patchwork:begin': }
  anchor { 'patchwork:end': }

  include 'patchwork::install'
  include 'patchwork::database::mysql'
  include 'patchwork::config'
  include 'patchwork::cron'

  Anchor['patchwork:begin'] ->
    Class['patchwork::install'] ->
    Class['patchwork::config'] ->
    Class['patchwork::database::mysql'] ->
    Class['patchwork::cron'] ->
  Anchor['patchwork:end']

}

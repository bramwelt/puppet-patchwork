# == Class: patchwork::config
#
# Manages the Patchwork settings file
#
# === Parameters
#
# [*location*]
#   Location patchwork should be cloned to.
#
#   Default: '/opt/patchwork'
#
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
class patchwork::config (
  $secret_key         = undef,
  $time_zone          = 'Etc/UTC',
  $language_code      = 'en_US',
  $patches_per_page   = '100',
  $force_https_links  = 'False',
  $from_email         = 'Patchwork <patchwork@patchwork.example.com>',
  $notification_delay = $patchwork::cron_minutes,
) inherits patchwork {

  file { "${patchwork::install_dir}/patchwork/settings/production.py":
    ensure  => file,
    mode    => '0644',
    owner   => $patchwork::user,
    group   => $patchwork::group,
    content => template("${module_name}/settings.py.erb"),
  }

  file { "${patchwork::install_dir}/patchwork/patchwork.wsgi":
    ensure => file,
    mode   => '0644',
    owner  => $patchwork::user,
    group  => $patchwork::group,
    source => 'puppet:///modules/patchwork/patchwork.wsgi',
  }

}

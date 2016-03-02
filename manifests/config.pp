# == Class: patchwork::config
#
# Manages the Patchwork settings file
#
# === Variables
#
# [*secret_key*]
#   A secret key for a particular Django installation. This is used to
#   provide cryptographic signing, and should be set to a unique,
#   unpredictable value.
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-SECRET_KEY
#
# === Parameters
#
# [*time_zone*]
#   A string representing the time zone for this installation.
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-TIME_ZONE
#
# [*language_code*]
#   A string representing the language code for this installation.
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-LANGUAGE_CODE
#
# [*patches_per_page*]
#   Number of patches listed on each page of a project's patch listing.
#
# [*force_https_links*]
#   Set to True to always generate https:// links instead of guessing
#   the scheme based on current access. This is useful if SSL protocol
#   is terminated upstream of the server (e.g. at the load balancer)
#
# [*from_email*]
#   Sets the email address patch notifications, error messages, and
#   validation emails come from.
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-DEFAULT_FROM_EMAIL
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-SERVER_EMAIL
#
# [*admins*]
#   A mapping of full names to email addresses. Email addresses listed here
#   will receive emails on server errors which may contain sensitive
#   information.
#   ```
#   {
#     'Django Admin' => 'admin@example.com',
#   }
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-ADMINS
#
# [*allowed_hosts*]
#   A list of strings representing the host/domain names that this Django
#   site can serve.
#
#   https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-ALLOWED_HOSTS
#
# [*notification_delay*]
#   This should be set to the same as `cron_minutes`. Number of minutes
#   patchwork should send Email notifications.
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
  $admins             = {},
  $allowed_hosts      = [],
  $notification_delay = $patchwork::cron_minutes,
) inherits patchwork {

  validate_string($secret_key)
  validate_string($time_zone)
  validate_string($patches_per_page)
  validate_string($force_https_links)
  validate_string($from_email)
  validate_hash($admins)
  validate_array($allowed_hosts)

  file { "${patchwork::install_dir}/patchwork/settings/production.py":
    ensure    => file,
    mode      => '0644',
    owner     => $patchwork::user,
    group     => $patchwork::group,
    content   => template("${module_name}/settings.py.erb"),
    show_diff => false,
  }

  file { "${patchwork::install_dir}/patchwork.wsgi":
    ensure => file,
    mode   => '0644',
    owner  => $patchwork::user,
    group  => $patchwork::group,
    source => 'puppet:///modules/patchwork/patchwork.wsgi',
  }

}

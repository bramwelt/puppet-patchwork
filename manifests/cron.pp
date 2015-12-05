# == Class: patchwork::cron
#
# Manages patchworks' cron job for expiring registrations and sending patch
# change notification
#
# == Parameters
# 
# [*virtualenv*]
#   File path to patchwork's python virtual environment.
#
# [*location*]
#   File path to the installation directory of patchwork.
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
class patchwork::cron (
  $virtualenv,
  $location,
) {

  cron { 'patchwork':
    ensure      => present,
    command     => '${virtualenv}/bin/python ${location}/manage.py cron',
    environment => 'PATH=/usr/bin/:/usr/local/bin:/usr/sbin', # Just an example
    minute      => '*/10',
  }
}

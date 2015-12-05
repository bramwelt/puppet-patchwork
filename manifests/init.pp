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
  $location          = $patchwork::params::location,
  $virtualenv_path   = $patchwork::params::virtualenv,
  $version           = $patchwork::params::version,
  $source_repo       = $patchwork::params::source_repo,
  $manage_git        = true,
  $manage_python     = true,
  $manage_database   = true,
) inherits patchwork::params {

  validate_string($location)
  validate_string($virtualenv_path)
  validate_string($version)
  validate_string($source_repo)

  validate_bool($manage_git)
  validate_bool($manage_python)
  validate_bool($manage_database)

  if ($manage_git) {
    include ::git
  }

  if ($manage_python) {
    class { '::python':
      gunicorn => 'absent',
    }
  }

  class { 'patchwork::database::mysql':
    manage_database => $manage_database,
  }

  # If 'latest' version is given the repo will track master and keep up
  # to date; provided patchwork uses master as their development branch
  if ($version == 'latest') {
      $vcsrepo_ensure = 'latest'
      $revision = 'master'
  } else {
      $vcsrepo_ensure = 'present'
      $revision = $version
  }

  vcsrepo { $location:
    ensure   => $vcsrepo_ensure,
    provider => 'git',
    source   => $source_repo,
    revision => $revision,
  }

  # Install requirements.txt
  python::virtualenv { $virtualenv_path:
    requirements => "${location}/doc/requirements-prod.txt",
  }

  class { 'patchwork::cron':
    location   => $location,
    virtualenv => $virtualenv_path,
  }
}

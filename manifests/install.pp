# == Class: patchwork::install
#
# Manages the installation of Patchwork
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
class patchwork::install {

  if ($patchwork::git_manage) {
    class { '::git': }
  }

  if ($patchwork::python_manage) {
    class { '::python':
      version    => 'system',
      dev        => true,
      pip        => true,
      virtualenv => true,
      gunicorn   => false,
    }
  }

  if ($patchwork::database_manage) {
    class { '::mysql::server': }
    # Manually install mariadb-devel until mysql module updates with the code
    # that fixes this.
    #class { '::mysql::bindings::daemon_dev': }
    package { 'mysql-daemon_dev':
      ensure => 'present',
      name   => 'mariadb-devel',
    }
    class { '::mysql::bindings':
      python_enable => true,
    }
  }

  # If 'latest' version is given the repo will track master and keep up
  # to date; provided patchwork uses master as their development branch
  case $patchwork::version {
    'latest': {
      $vcsrepo_ensure = 'latest'
      $revision       = 'master'
    }
    default: {
      $vcsrepo_ensure = 'present'
      $revision       = $patchwork::version
    }
  }

  user { 'patchwork':
    ensure  => present,
    comment => 'User for managing Patchwork',
    name    => $patchwork::user,
    home    => $patchwork::install_dir,
    system  => true,
  }

  file { $patchwork::install_dir:
    ensure => 'directory',
    owner  => $patchwork::user,
    group  => $patchwork::group,
  }

  vcsrepo { $patchwork::install_dir:
    ensure   => $vcsrepo_ensure,
    provider => 'git',
    user     => $patchwork::user,
    group    => $patchwork::group,
    source   => $patchwork::source_repo,
    revision => $revision,
    force    => true,
    require  => File[$patchwork::install_dir],
  }

  # Creat a virtualenv and install patchwork's requirements.txt
  python::virtualenv { $patchwork::virtualenv_dir:
    owner   => $patchwork::user,
    group   => $patchwork::group,
    require => [
      Class['python'],
      Vcsrepo[$patchwork::install_dir],
    ],
  }

  python::requirements { $patchwork::requirements:
    virtualenv  => $patchwork::virtualenv_dir,
    owner       => $patchwork::user,
    group       => $patchwork::group,
    forceupdate => true,
    require     => [
      Class['python'],
      Python::Virtualenv[$patchwork::virtualenv_dir],
    ],
  }

}

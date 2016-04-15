# patchwork

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [patchwork](#patchwork-1)
    * [patchwork::config](#patchworkconfig)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [Release Notes/Changelog - What the module does and why it is useful](#release-noteschangelog)

## Overview

[![Build Status](https://travis-ci.org/bramwelt/puppet-patchwork.png)](https://travis-ci.org/bramwelt/puppet-patchwork)

A Puppet module for managing deployments of
[Patchwork](http://http://jk.ozlabs.org/projects/patchwork/) - the
web-based patch tracking system

## Usage

To use this module you can either directly include it in your module
tree, or add the following to your `Puppetfile`:

```
  mod 'bramwelt-patchwork'
```

A node should then be assigned the relevant patchwork classes.

```puppet
  class { 'patchwork':
    version => 'v1.0.0'
  }
  class { 'patchwork::config':
    secret_key    => 'CHANGEME',
    allowed_hosts => ['localhost', '.example.com']
  }
```

A secret key can be generated with the following Linux command:

```shell
  $ pwgen -sync 50 1 | tr -d "'\""
```

If you're using Hiera, a basic yaml configuration might look like:

```yaml
  patchwork::version: 'v1.0.0'
  patchwork::config::secret_key: 'CHANGEME'
  patchwork::config::allowed_hosts:
     - 'localhost'
     - '.example.com'
```

After Packwork has been installed and configured, it is up to you to
manage the application deployment. This includes:

 - Initializing / Migrating the Database: `./manage.py migrate --noinput`
 - Loading fixtures `./manage.py loaddata default_tags default_states`
 - Collecting Static files: `./manage.py collectstatic`
 - Creating admin(s)/superuser(s): `./manage.py createsuperuser`

## Reference

### patchwork

#### `install_dir`

The directory where patchwork should be installed.

Default: `'/opt/patchwork'`

#### `virtualenv_dir`

The directory where the virtualenv should reside.

Default: `'/opt/patchwork/venv'`

#### `version`

Version of patchwork to be installed.

If 'latest' is specified, the installation will track the tip of the
patchwork 'master' branch, otherwise the repo will be ensured
'present' overwriting any local changes that take place.

Default: `'master'`

#### `source_repo`

git repo URL for cloning patchwork. Useful for installing your own fork
/ patched version of patchwork.

Default: `'git://github.com/getpatchwork/patchwork'`

#### `user`

User that owns patchwork files and runs the application.

Default `'patchwork'`

#### `group`

Group that has access to patchwork files.

Default: `'patchwork'`

#### `manage_git`

Installs git. Git is required for cloning patchwork.

Default: `true`

#### `manage_python`

Installs python, python development libraries, pip, and virtualenv.
Required for creating the patchwork virtualenv and installing
patchwork's dependencies.

Default: `true`

#### `manage_database`

Installs a local MySQL server.

Default: `true`

#### `database_name`

The name of the patchwork database.

Default: `'patchwork'`

#### `database_host`

The hostname of the database server.

Default: `'localhost'`

#### `database_user`

The username for connection to the database.

Default: `'patchwork'`

#### `database_pass`

The password associated with the database username.

Default: `'patchwork'`

#### `database_tag`

Exported resource tag to for collecting the database resource onto a
database server.

Default: `'mysql-patchwork'`

#### `uwsgi_overrides`

Items in the hash will replace the defaults listed in `uwsgi_options` of
the params class.

`patchwork::params::uwsgi_options` is defined as:
```puppet
{
  virtualenv  => '/opt/patchwork/venv',
  chdir       => '/opt/patchwork',
  static-map  => '/static=/opt/patchwork/htdocs',
  logto       => '/var/log/patchwork/uwsgi.log',
  master      => true,
  http-socket => ':9000',
  wsgi-file   => 'patchwork.wsgi',
  processes   => 4,
  threads     => 2,
}
```

Default: `{}`

#### `collect_exported`

Changes database definition from a regular resource to an exported
resource and allows for creating the database on another server. Also see:
[database_tag](#database_tag)

Default: `false`

#### `cron_minutes`

Patchwork uses a cron script to clean up expired registrations, and send
notifications of patch changes (for projects with this enabled). This
setting defines the number of minutes between patchwork cron job runs.

There is no need to modify `notification_delay` since
setting `cron_minutes` will also set `patchwork::config::notification_delay`.

Default: `10`

### patchwork::config

Manages the Django settings.py file. Most parameter are passed directly
through and interpreted as Python. Because settings.py may contain
sensitive information,
[show_diff](https://docs.puppetlabs.com/puppet/latest/reference/type.html#file-attribute-show_diff)
is disabled for the file.

#### `secret_key`

A secret key for a particular Django installation. This is used to
provide cryptographic signing, and should be set to a unique,
unpredictable value.

See: [SECRET_KEY](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-SECRET_KEY)

Default: `undef`

#### `time_zone`

A string representing the time zone for this installation.

See: [TIME_ZONE](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-TIME_ZONE)

Default: `'Etc/UTC'`

#### `language_code`

A string representing the language code for this installation.

See: [LANGUAGE_CODE](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-LANGUAGE_CODE)

Default: `'en_US'`

#### `patches_per_page`

Number of patches listed on each page of a project's patch listing.

Default: `'100'`

#### `force_https_links`

Set to True to always generate https:// links instead of guessing
the scheme based on current access. This is useful if SSL protocol
is terminated upstream of the server (e.g. at the load balancer)

Default: `'False'`

#### `from_email`

Sets the email address patch notifications, error messages, and
validation emails come from.

See:
 - [DEFAULT_FROM_EMAIL](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-DEFAULT_FROM_EMAIL)
 - [SERVER_EMAIL](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-SERVER_EMAIL)

Default: `'Patchwork <patchwork@patchwork.example.com>'`

#### `admins`

A mapping of full names to email addresses. Email addresses listed here
will receive emails on server errors which may contain sensitive
information.
```puppet
{
  'Django Admin' => 'admin@example.com',
}
```

See: [ADMINS](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-ADMINS)

Default: `{}`

#### `allowed_hosts`

A list of strings representing the host/domain names that this Django
site can serve.

See: [ALLOWED_HOSTS](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-ALLOWED_HOSTS)

Default: `[]`

#### `notification_delay`

This should be set to the same as `cron_minutes`. Number of minutes
patchwork should send Email notifications.

Default: `10` - Set by [cron_minutes](#cron_minutes)

#### `enable_xmlrpc`

Set to True to enable the Patchwork XML-RPC interface. This is needed
for pwclient usage.

Default: `'False'`

### patchwork::selinux

Manages an optional selinux module for Patchwork.
Expects the class `::selinux::base` to exist. This class is provided by
the `camptocamp/selinux` module and can be installed by adding:

```
  mod 'camptocamp-selinux'
```

to Puppetfile, or running:

```
puppet module install camptocamp-selinux
```

#### `module_source`

Location of a patchwork selinux module to override the one provided
by puppet.

Default: `puppet:///module/patchwork/mypatchwork.te`

## Limitations

This module has been tested to work with Puppet 4 on the following
operating systems:

 - CentOS 7

MySQL is currently the only supported database backend for Django.

## Development

Patches can be submitted by forking this repo and submitting a
pull-request. Along with code changes, patches must include with the
following materials:

 - Tests
 - Documentation

## Release Notes/Changelog

Please see the [CHANGELOG](CHANGELOG.md) for a list of changes available
in the current and previous releases.

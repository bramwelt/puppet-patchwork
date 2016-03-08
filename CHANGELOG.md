# Changelog

## 2016-03-08 - v0.2.0

* [#6](https://github.com/bramwelt/puppet-patchwork/pull/6) Allow Overriding of uwsgi Parameters

  * Removes `patchwork::uwsgi_options`
  * Adds    `patchwork::uwsgi_overrides`

## 2016-03-02 - v0.1.2

* [#4](https://github.com/bramwelt/puppet-patchwork/pull/4) Disable reporting changes to settings.py

## 2016-02-26 - v0.1.1

* [#1](https://github.com/bramwelt/puppet-patchwork/pull/1) Ensure 'manage_database' only manages the server
* [#2](https://github.com/bramwelt/puppet-patchwork/pull/2) Use 'include' for classes declared by managed flagsbramwelt/puppet-patchwork#2) Use 'include' for classes declared by managed flags

## 2016-02-22 - v0.1.0 Initial Release

* Install Patchwork through git and manage settings.py

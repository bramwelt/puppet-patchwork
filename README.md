# patchwork


## Overview

A Puppet module for managing deployments of Patchwork - the web-based
patch tracking system

## Usage

To use this module you can either directly include it in your module
tree, or add the following to your `Puppetfile`:

  mod 'bramwelt-patchwork'

A node should then be assigned the relevant patchwork classes.

  class { 'patchwork': }

### patchwork

The `patchwork` class installs and configures a production patchwork
install.

## Limitations

This module has been tested to work with Puppet 4 on the following
operating systems:

 - CentOS 6
 - CentOS 7

## Development

Patches can be submitted by forking this repo and submitting a
pull-request. Along with code changes, patches must include with the
following materials:

 - Tests
 - Documentation

## Release Notes/Changelog

Please see the [CHANGELOG](CHANGELOG.md) for a list of changes available
in the current and previous releases.

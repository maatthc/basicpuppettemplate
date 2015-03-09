# rea

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with rea](#setup)
    * [What rea affects](#what-rea-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rea](#beginning-with-rea)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This is a simple Puppet Template for setting up a Linux (CentOS 5.9) with Nginx, Unicorn and a 'Hello World' Sinatra App. 

## Module Description

This module will provide a Web site running on the Agent server at port 80 and deliver the Ruby App available at git://github.com/tnh/simple-sinatra-app.git .

This module has been validated using "puppet-lint" but the "line has more than 80 characters" item has ignored.

The dependencies of the module are :
* puppetlabs-firewall
* puppetlabs-ntp
* saz-ssh
* huit-splunk
* puppetlabs-ruby

## Setup
Please follow this steps as "root" :

*    curl -L https://github.com/maatthc/rea/tarball/master -o maat-rea.tgz
*    puppet module install maat-rea.tgz
*    ln -s /etc/puppet/modules/rea/ext/site.pp /etc/puppet/manifests/site.pp
*    ln -s /etc/puppet/modules/rea/ext/hiera.yaml /etc/puppet/hiera.yaml
*    Add to the main session of /etc/puppet/puppet.conf:

        # To user the "each" function for Array from Hiera

        parser = future

*    /etc/init.d/puppetmaster restart

### What rea affects

Please keep in mind that this module should overwrite:
* /etc/puppet/manifests/site.pp
* /etc/puppet/hiera.yaml

Please use a vanila installation of Puppet. 

### Setup Requirements 

* Puppet-2.7.0 or later
* Facter 1.7.0 or later
* Ruby-1.9.3

## Usage
This is the module structure:

* changeModuloname.sh

        Use this script to create new vanila template for other initial Puppet Projects
* ext
        
        The default site.pp and hiera.yaml are here
* hieradata

        The Hiera database files reside here
* manifests

        Classes/Roles/Profiles are here 
* metadata.json

        Module definition and dependencies
* README.md

        This file
* templates

        Module template used for many classes

The other files are not being used and were created automatically for the Puppet Module generator.

## Reference

This module uses modules available at Forge (https://forge.puppetlabs.com/) as much as possible to avoid rewriting the wheel. Some modules available there were ignored for not having enough support, quality or being to complex for this test.

## Limitations

This module has been tested only using CentOs 5.9. Although there is a draft support for Debian or Ubuntu using Hiera files.

## Development

Please fell free to submit any suggestions using the GitHub "Pull Request". 

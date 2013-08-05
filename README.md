# Puppet module: nodejs

This is a Puppet module that installs nodejs and npm.

Based on [puppetlabs-nodejs module](https://github.com/puppetlabs/puppetlabs-nodejs) but modified
to the follow Example42 "NextGen" modules' format.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-nodejs

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install nodejs with default settings

        class { 'nodejs': }

* Install a specific version of nodejs package

        class { 'nodejs':
          version => '1.0.1',
        }

* Remove nodejs resources

        class { 'nodejs':
          absent => true
        }

* Enable auditing without without making changes on existing nodejs configuration *files*

        class { 'nodejs':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'nodejs':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'nodejs':
          source => [ "puppet:///modules/example42/nodejs/nodejs.conf-${hostname}" , "puppet:///modules/example42/nodejs/nodejs.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'nodejs':
          source_dir       => 'puppet:///modules/example42/nodejs/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'nodejs':
          template => 'example42/nodejs/nodejs.conf.erb',
        }

* Automatically include a custom subclass

        class { 'nodejs':
          my_class => 'example42::my_nodejs',
        }



## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-nodejs.png?branch=master)](https://travis-ci.org/netmanagers/puppet-nodejs)

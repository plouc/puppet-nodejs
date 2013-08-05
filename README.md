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



### npm package

Two types of npm packages are supported.

* npm global packages are supported via ruby provider for puppet package type.
* npm local packages are supported via puppet define type nodejs::npm.

For more information regarding global vs. local installation see [nodejs blog](http://blog.nodejs.org/
2011/03/23/npm-1-0-global-vs-local-installation/)

### package
npm package provider is an extension of puppet package type which supports versionable and upgradeable
. The package provider only handles global installation:

Example:

    package { 'express':
      ensure   => latest,
      provider => 'npm',
    }
    
    package { 'mime':
      ensure   => '1.2.4',
      provider => 'npm',
    }


### nodejs::npm
nodejs::npm is suitable for local installation of npm packages:

    nodejs::npm { 'express_2.5.9':
      pkg_name    => 'express',
      install_dir => /opt/razor,
      ensure      => present,
      version     => '2.5.9',
    }

If you don't specify *pkg_name*, *title* becomes the name of the package to install.

install_dir defaults to $npm_local_dir (/opt/razor) if not specified.

So, a shortest case to write the example above should be:

    nodejs::npm { 'express':
      version     => '2.5.9',
    }

See define file for parameters description.

## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-nodejs.png?branch=master)](https://travis-ci.org/netmanagers/puppet-nodejs)

# Class: nodejs::params
#
# This class defines default parameters used by the main module class nodejs
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to nodejs class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class nodejs::params {

  ### Application related parameters

  $nodejs_package = $::operatingsystem ? {
    /(?i:RedHat|CentOS|Scientific|Amazon|OEL|OracleLinux|Fedora)/ => 'nodejs-compat-symlinks',
    default                                                       => 'nodejs',
  }

  $npm_package = $::operatingsystem ? {
    default => 'npm',
  }

  $npm_proxy = ''

  $config_dir = $::operatingsystem ? {
    default => '/etc/nodejs',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/nodejs/nodejs.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false

}

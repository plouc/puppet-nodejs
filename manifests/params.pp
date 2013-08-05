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
  $npm_local_dir = '/opt/razor'

  # General Settings
  $my_class = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false
}

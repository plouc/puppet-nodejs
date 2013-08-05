# = Class: nodejs
#
# This is the main nodejs class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, nodejs class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $nodejs_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, nodejs main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $nodejs_source
#
# [*source_dir*]
#   If defined, the whole nodejs configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $nodejs_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $nodejs_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, nodejs main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $nodejs_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $nodejs_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $nodejs_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $nodejs_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in nodejs::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*nodejs_package*]
#   The name of nodejs package
#
# [*npm_package*]
#   The name of npm package
#
# [*npm_proxy*]
#   If npm uses a proxy, specify it here.
#   Default: empty
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include nodejs"
# - Call nodejs as a parametrized class
#
# See README for details.
#
#
class nodejs (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $nodejs_package      = params_lookup( 'nodejs_package' ),
  $npm_package         = params_lookup( 'npm_package' ),
  $npm_proxy           = params_lookup( 'npm_proxy' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits nodejs::params {

  $config_file_mode=$nodejs::params::config_file_mode
  $config_file_owner=$nodejs::params::config_file_owner
  $config_file_group=$nodejs::params::config_file_group

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $nodejs::bool_absent ? {
    true  => 'absent',
    false => $nodejs::version,
  }

  $manage_file = $nodejs::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $nodejs::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $nodejs::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $nodejs::source ? {
    ''        => undef,
    default   => $nodejs::source,
  }

  $manage_file_content = $nodejs::template ? {
    ''        => undef,
    default   => template($nodejs::template),
  }

  ### Managed resources
  package { $nodejs::nodejs_package:
    ensure  => $nodejs::manage_package,
    noop    => $nodejs::bool_noops,
  }

  package { $nodejs::npm_package:
    ensure  => $nodejs::manage_package,
    noop    => $nodejs::bool_noops,
  }

  if $npm_proxy != '' {
    exec { 'npm_proxy':
      command => "npm config set proxy ${nodejs::npm_proxy}",
      path    => $::path,
      require => Package[$nodejs::npm_package],
    }
  }

  file { 'nodejs.conf':
    ensure  => $nodejs::manage_file,
    path    => $nodejs::config_file,
    mode    => $nodejs::config_file_mode,
    owner   => $nodejs::config_file_owner,
    group   => $nodejs::config_file_group,
    require => Package[$nodejs::nodejs_package],
    source  => $nodejs::manage_file_source,
    content => $nodejs::manage_file_content,
    replace => $nodejs::manage_file_replace,
    audit   => $nodejs::manage_audit,
    noop    => $nodejs::bool_noops,
  }

  # The whole nodejs configuration directory can be recursively overriden
  if $nodejs::source_dir {
    file { 'nodejs.dir':
      ensure  => directory,
      path    => $nodejs::config_dir,
      require => Package[$nodejs::nodejs_package],
      source  => $nodejs::source_dir,
      recurse => true,
      purge   => $nodejs::bool_source_dir_purge,
      force   => $nodejs::bool_source_dir_purge,
      replace => $nodejs::manage_file_replace,
      audit   => $nodejs::manage_audit,
      noop    => $nodejs::bool_noops,
    }
  }


  ### Include custom class if $my_class is set
  if $nodejs::my_class {
    include $nodejs::my_class
  }

}

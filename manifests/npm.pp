# Define: nodejs::npm
#
# Taken from https://github.com/puppetlabs/puppetlabs-nodejs and adapted
#
# [*pkg_name*]
#   Package 
# [*install_dir*]
# [*ensure*]
#   present, absent.
# [*version*]
#   package version (optional). 
# [*source*]
#   package source (optional).
# [*install_opt*]
#   option flags invoked during installation such as --link (optional).
# [*remove_opt*]
#   option flags invoked during removal (optional). 
#
define nodejs::npm (
  $pkg_name    = '',
  $install_dir = '',
  $version     = undef,
  $source      = undef,
  $install_opt = undef,
  $remove_opt  = undef,
  $ensure      = present
) {
  include nodejs

  $real_install_dir = $install_dir ? {
    ''      => $nodejs::npm_local_dir,
    default => $install_dir,
  }

  $real_pkg_name = $pkg_name? {
    ''      => $title,
    default => $pkg_name,
  }

  if $source {
    $install_pkg = $source
  } elsif $version {
    $install_pkg = "${real_pkg_name}@${version}"
  } else {
    $install_pkg = $real_pkg_name
  }

  if $version {
    $validate = "${real_install_dir}/node_modules/${real_pkg_name}:${real_pkg_name}@${version}"
  } else {
    $validate = "${real_install_dir}/node_modules/${real_pkg_name}"
  }

  if $ensure == present {
    exec { "npm_install_${real_pkg_name}":
      command => "npm install ${install_opt} ${install_pkg}",
      unless  => "npm list -p -l | grep '${validate}'",
      cwd     => $real_install_dir,
      path    => $::path,
      require => Class['nodejs'],
    }

    # Conditionally require npm_proxy only if resource exists.
    Exec<| title=='npm_proxy' |> -> Exec["npm_install_${real_pkg_name}"]
  } else {
    exec { "npm_remove_${real_pkg_name}":
      command => "npm remove ${real_pkg_name}",
      onlyif  => "npm list -p -l | grep '${validate}'",
      cwd     => $real_install_dir,
      path    => $::path,
      require => Class['nodejs'],
    }
  }
}

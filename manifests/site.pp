require 'stdlib'

Exec {
  logoutput => on_failure,
  path      => [
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin',
  ]
}

hiera_include('classes')

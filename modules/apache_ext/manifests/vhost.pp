
define apache_ext::vhost(
  $servername         = $title,
  $serveraliases      = [],
  $port               = 80,
  $ssl                = false,
  $no_proxy_uris      = [],
  $proxy_pass         = [],
  $directories        = undef,
  $rewrites           = undef,
  $logrotate_cycle    = 14,
  $logrotate_every    = 'day',
  $vhost_root         = "/srv/httpd/${title}",
  $logroot            = "/srv/httpd/${title}/log",
  $docroot            = "/srv/httpd/${title}/public",
  $access_log_file    = 'access.log',
  $access_log_format  = 'ltsv',
  $access_log_env_var = undef,
  $error_log_file     = 'error.log',
  $log_level          = 'warn',
) {

  require 'apache_ext'

  $docroot_directory = {
    'path'           => $docroot,
    'options'        => 'FollowSymlinks',
    'allow_override' => 'None',
    'provider'       => 'directory',
  }
  $_directories = $directories ? {
    undef   => $docroot_directory,
    default => concat([$docroot_directory], $directories),
  }

  file {
    [
      $vhost_root,
      $docroot,
      $logroot,
    ]:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
  }

  apache::vhost { $title:
    docroot            => $docroot,
    servername         => $servername,
    serveraliases      => $serveraliases,
    port               => $port,
    ssl                => $ssl,
    directories        => $_directories,
    rewrites           => $rewrites,
    logroot            => $logroot,
    access_log_file    => $access_log,
    access_log_format  => $access_log_format,
    access_log_env_var => $access_log_env_var,
    error_log_file     => $error_log,
    log_level          => $log_level,
    setenvif           => $setenvif,
  }

  Logrotate::Rule {
    rotate_every => $logrotate_every,
    rotate       => $logrotate_cycle,
    copytruncate => true,
  }

  logrotate::rule {
    "${title}.httpd.access":
      path => "${logroot}/${access_log}";

    "${title}.httpd.error":
      path => "${logroot}/${error_log}";
  }
}

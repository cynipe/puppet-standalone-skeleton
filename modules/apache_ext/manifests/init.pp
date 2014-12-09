
class apache_ext {
  include apache

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['httpd'],
  }

  file {
    '/srv/httpd':
      ensure => directory;

    '10-ltsv.conf':
      path   => "${::apache::params::vhost_dir}/10-ltsv.conf",
      source => 'puppet:///modules/apache_ext/ltsv.conf',
      notify => Service['httpd'];
  }
}

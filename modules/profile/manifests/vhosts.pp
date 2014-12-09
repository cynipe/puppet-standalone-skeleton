
class profile::vhosts {
  $vhosts = hiera_hash('apache_ext::vhost')
  create_resources('apache_ext::vhost', $vhosts)
}

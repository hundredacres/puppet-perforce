# == Class: perforce::server
#
class perforce::server(
  $user = 'perforce',
  $version = '14.1') {

  File {
    owner => $user,
    group => $user,
  }

  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin' }

  user { $user:
    ensure     => present,
    home       => '/export/perforce',
    managehome => true,
    system     => true,
  } ->

  wget { 'p4d':
    path   => '/usr/local/bin/p4d',
    source => "http://www.perforce.com/downloads/perforce/r${version}/bin.linux26${::architecture}/p4d",
  } ->
  file { '/usr/local/bin/p4d':
    mode => '0755',
  } ->
  file { '/export/perforce':
    ensure => directory,
  } ->
  exec { 'p4d -r /export/perforce':
    unless => 'pidof p4d',
  }

}

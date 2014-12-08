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

  wget::fetch { 'p4d':
    source      => 'http://cdist2.perforce.com/perforce/r14.1/bin.linux26x86_64/p4d',
    destination => '/usr/bin',
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

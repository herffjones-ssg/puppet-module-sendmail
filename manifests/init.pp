# == Class: sendmail
#
# Installs sendmail and configures mail.herffjones.hj-int to be used as a mail forwarder.
#
class sendmail (
  $mail_server = "mail.${::domain}",
  $packages    = ['sendmail',
                  'sendmail-cf',
                  'm4'],
  $disable_postfix = 'true',
) {

  if $disable_postfix == 'true' {
    class { 'postfix':
      ensure => 'absent',
    }
  }

  package { 'sendmail_packages':
    ensure => 'installed',
    name   => $packages,
  }

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['sendmail_packages'],
    notify  => Service['sendmail'],
  }

  file { 'sendmail_local_host_names':
    path    => '/etc/mail/local-host-names',
    content => template('sendmail/local-host-names.erb'),
  }

  file { 'sendmail_config':
    path    => '/etc/mail/sendmail.mc',
    content => template('sendmail/sendmail-mc.erb'),
  }

  service { 'sendmail':
    ensure => 'running',
    enable => true,
  }
}

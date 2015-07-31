# ===   Class: hpinsight
class hpinsight(
  $ensure                  = 'present',
  $snmp_manage             = false,
  $snmp_dlmod              = undef,
  $snmp_rocommunity        = undef,
  $snmp_rocommunity_allow  = undef,
  $snmp_trapcommunity      = undef,
  $snmp_trapsink_host      = undef,
  $snmp_trapsink_community = undef,

) {

# Load default parameters according to OS

  case $::osfamily {
    'RedHat', 'Suse': {
      $snmp_package = 'net-snmp'
      $snmp_service = 'snmpd'
      $snmp_config  = '/etc/snmp/snmpd.conf'
      case $::architecture {
        'x86_64': {
          $snmp_dlmod = '/usr/lib64/libcmaX64.so'
        }
        default: {
          $snmp_dlmod = '/usr/lib/libcmaX.so'
        }
      }
    }
    'Debian': {
      $snmp_package = 'snmpd'
      $snmp_service = 'snmpd'
      $snmp_config  = '/etc/snmp/snmpd.conf'
      $snmp_dlmod   = '/usr/lib64/libcmaX64.so'
    }
    default: {
      fail("autofs supports osfamilies RedHat, Suse and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }

# Validation of input

  validate_re($ensure, '^(present|absent)$', "hpinsight::ensure may be either 'present' or 'absent' but is set to <${ensure}>")

  validate_bool($snmp_manage)


# Configure snmp

  if $snmp_manage == true {
    validate_string($snmp_dlmod)
    validate_string($snmp_rocommunity)
    validate_string($snmp_rocommunity_allow)
    validate_string($snmp_trapcommunity)
    validate_string($snmp_trapsink_host)
    validate_string($snmp_trapsink_community)

    package { $snmp_package:
      ensure  => present,
    }

    file { $snmp_config:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template("hpinsight/snmp.conf.erb"),
      require => Package[$snmp_package],
      notify  => Service[$snmp_service],
    }

    service { $snmp_service:
      ensure  => running,
      enable  => true,
    }
  }
}

# == Class: hpinsight
#
# Manage HP Insight
#
class hpinsight(
  $ensure 					= 'present',
  $service					= 'running',
  ) {

# Load default parameters according to OS

  case $::osfamily {
    'RedHat', 'Suse': {
      $hpi_packages = [ 'hp-health', 'hp-snmp-agents']
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
      $hpi_packages = [ 'hp-health', 'hp-snmp-agents']
      $snmp_package = 'snmpd'
      $snmp_service = 'snmpd'
      $snmp_config  = '/etc/snmp/snmpd.conf'
      $snmp_dlmod   = '/usr/lib64/libcmaX64.so'
    }

    default: {
      fail("autofs supports osfamilies RedHat, Suse and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }

 package {$snmp_package:
	ensure => present,
	}

 service { $snmp_service:
      ensure  => running,
      enable  => true,
    }

 file { $snmp_config:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      source => 'puppet:///fiiles/snmpd.conf',
      require => Package[$snmp_package],
      notify  => Service[$snmp_service],
    }


# HP Insight

  package { $hpi_packages:
      ensure  => $ensure,
  }

   
  service { hp-snmp-agents:
      ensure   => $service,
	 enable  => true,
      require => Package[$hpi_packages],
  }

  service { hp-health:
      ensure  => $service,
      enable  => true,
      require => Package[$hpi_packages],
  }

}

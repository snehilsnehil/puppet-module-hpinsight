# puppet-module-hpinsight

Puppet module to setup HP Insight hardware monitoring packages

===

# Compatibility

This module has been tested to work on the following systems with Puppet v3 (with and without the future parser) and Puppet v4 with Ruby versions 1.8.7, 1.9.3, 2.0.0 and 2.1.0.

  * EL5
  * EL6
  * EL7
  * Suse 10
  * Suse 11
  * Ubuntu 12.04
  * Ubuntu 14.04

===

# Parameters

ensure
------
String value controlling if the software is installed or removed. Valid values are 'present' and 'absent'.

- *Default*: present


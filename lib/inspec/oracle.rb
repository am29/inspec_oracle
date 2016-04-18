require 'inspec'
require_relative 'oracle/version'

#
# Require all resources
#
require_relative 'oracle/resources/ora_tablespace'
require_relative 'oracle/resources/ora_instance'
#
# Require all matchers
#
# require_relative 'oracle/matchers/...'

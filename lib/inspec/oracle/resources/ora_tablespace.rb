require_relative '../utils/sql_command'
require_relative '../utils/size'

class OraTablespace < Inspec.resource(1)
  name 'ora_tablespace'
  desc 'Use ora_tablespace InSpec audit resource to test an Oracle tablespace'

  def initialize(tablespace, sid, os_user = 'oracle')
    @tablespace  = tablespace
    @sid         = sid
    @os_user     = os_user
    @sql         = Oracle::SqlCommand.new(self, :sid => @sid, :os_user => @os_user)
    @tablespaces = sql  "select * from dba_tablespaces where tablespace_name = '#{tablespace}'"
  end

  def exists?
    @tablespaces.size == 1
  end

  def bigfile?
    tablespace['big'] == 'YES'
  end

  def smallfile?
    tablespace['big'] != 'YES'
  end

  def block_size
    ::Size.new(tablespace['BLOCK_SIZE'])
  end

  def initial_extent
    tablespace['INITIAL_EXTENT'].to_i
  end

  def next_extent
    tablespace['NEXT_EXTENT'].to_i
  end

  def min_extents
    tablespace['MIN_EXTENTS'].to_i
  end

  def max_extents
    tablespace['MAX_EXTENTS'].to_i
  end

  def max_size
    tablespace['MAX_SIZE'].to_i
  end

  def pct_increase
    tablespace['PCT_INCREASE'].to_i
  end

  def min_extlen
    tablespace['MIN_EXTLEN'].to_i
  end

  def status
    tablespace['STATUS'].to_i
  end

  def contents
    tablespace['CONTENTS'].to_i
  end

  def logging
    tablespace['LOGGING'].to_i
  end

  def extent_management
    tablespace['EXTENT_MAN'].to_i
  end

  def allocation
    tablespace['ALLOCATION'].to_i
  end

  def to_s
    "Tablespace #{@tablespace} on SID #{@sid}"
  end

  private

  def tablespace
    @tablespaces.first
  end

  def sql(command)
    @sql.execute(command)
  end

end


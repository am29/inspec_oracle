require_relative '../utils/sql_command'

class OraInstance < Inspec.resource(1)
  name 'ora_instance'
  desc 'Use oracle_instance InSpec audit resource to test an Oracle instance'

  def initialize(sid, os_user = 'oracle')
    @sid     = sid
    @os_user = os_user
    @sql     = Oracle::SqlCommand.new(self, :sid => @sid, :os_user => @os_user)
  end

  def running?
    cmd = inspec.command("ps aux | grep oracle | grep _#{@sid}")
    processes = cmd.stdout.split("\n")[1..-1]
    processes.size >= 34   # If all 34 processes are running
  end

  def connectable?
    output = sql 'select * from dual'
    output.first.fetch('D') == 'X' # The first record of the output contains a 'X'
  end

  def sql(command)
    @sql.execute(command)
  end

  def to_s
    "SID #{@sid}"
  end
end


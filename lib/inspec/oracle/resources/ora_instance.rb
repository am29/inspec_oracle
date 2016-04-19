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
    cmd = inspec.command("ps aux | grep #{@os_user} | grep _#{@sid}")
    # check for processes pmon and smon
    processes = cmd.stdout.each_line.select {|l| l =~ /^#{@os_user}.*_(p|s)mon_#{@sid}$/}
    processes.size == 2
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


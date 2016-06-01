require_relative '../../helpers'
require 'securerandom'

module Oracle
  class SqlCommand
    include Helpers

    ORA_OS_USER_NAME  = 'ORA_OS_USER'
    ASM_OS_USER_NAME  = 'ASM_OS_USER'

    VALID_OPTIONS = [
      :sid,
      :os_user,
      :password,
      :username,
      :failonsqlfail,
      :parse            # Parse the output as cvs. We need this. This is default true
    ]

    attr_reader *VALID_OPTIONS

    def initialize(context, options)
      @context        = context
      @valid_options  = VALID_OPTIONS
      check_options( options )
      @command        = 'sqlplus -S /nolog '
      @password       = options[:password] # may be empty
      @failonsqlfail  = options.fetch(:failonsqlfail) {true}
      @sid            = options.fetch(:sid)
      if asm_sid?
        @os_user      = options.fetch(:os_user) {default_asm_user}
        @username     = options.fetch(:username){'sysasm'}
      else
        @os_user      = options.fetch(:os_user) {default_ora_user}
        @username     = options.fetch(:username){'sysdba'}
      end
      @parse          = options.fetch(:parse) { true}
    end

    def command_string(arguments = '')
      "su - #{@os_user} -c \"export ORACLE_SID=#{@sid};export ORAENV_ASK=NO;. oraenv; #{@command} #{arguments}\""
    end

    def execute(command)
      template_file = (Pathname.new(__FILE__).dirname + 'execute.sql.erb')
      template = File.read(template_file)
      input_file  = tempfile_name(['input', '.sql'])
      remote_file = tempfile_name(['input', '.sql'])
      output_file = tempfile_name(['output', '.csv'])
      content = ERB.new(template, nil, '-').result(binding)
      File.open(input_file, 'w') { |f| f.write(content) }
      @context.inspec.backend.upload(input_file, remote_file)
      @context.inspec.command("chown #{@os_user} #{remote_file}").stdout
      @context.inspec.command(command_string("@#{remote_file}")).stdout
      output = @context.inspec.file(output_file).content
      @context.inspec.command("rm #{remote_file} #{output_file}").stdout
      File.unlink(input_file)
      convert_csv_data_to_hash(output)
    end

    private

    def tempfile_name(options = [])
      "/tmp/#{options[0]}-#{SecureRandom.hex(10)}#{options[1]}"
    end

    def asm_sid?
      @sid =~ /\+ASM/
    end

    def check_options(options)
      options.each_key {| key|  raise ArgumentError, "option #{key} invalid for #{@command}. Only #{@valid_options.join(', ')} are supported" unless @valid_options.include?(key)}
    end

    def default_asm_user
      ENV[ASM_OS_USER_NAME] ||  Facter.value(ASM_OS_USER_NAME) || 'grid'
    end

    def default_ora_user
      ENV[ORA_OS_USER_NAME] ||  Facter.value(ORA_OS_USER_NAME) || 'oracle'
    end

  end
end

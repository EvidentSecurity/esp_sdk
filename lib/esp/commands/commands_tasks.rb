module ESP
  # This is a class which takes in an esp command and initiates the appropriate
  # initiation sequence.
  #
  # Warning: This class mutates ARGV because some commands require manipulating
  # it before they are run.
  class CommandsTasks # :nodoc:
    attr_reader :argv

    HELP_MESSAGE = <<-EOT
Usage: esp COMMAND [environment] [ARGS]

The ESP commands are:
 console                      Start the ESP console (short-cut alias: "c")
 add_external_account         Adds external accounts to ESP (short-cut alias: "a")

All commands can be run with -h (or --help) for more information.
    EOT

    COMMAND_WHITELIST = %w(console add_external_account version help)

    def initialize(argv)
      @argv = argv
    end

    def run_command!(command)
      command = parse_command(command)
      if COMMAND_WHITELIST.include?(command)
        set_env!
        require_relative '../../../lib/esp_sdk'
        send(command)
      else
        write_error_message(command)
      end
    end

    def console
      require_command!("console")

      print_banner
      ESP::Console.new.start
    end

    def add_external_account
      require_command!("add_external_account")
    end

    def version
      puts "ESP #{ESP::VERSION}" # rubocop:disable Rails/Output
      exit(0)
    end

    def help
      write_help_message
    end

    private

    def shift_argv!
      argv.shift if argv.first && argv.first[0] != '-'
    end

    def require_command!(command)
      require_relative "./#{command}"
    end

    def set_env!
      ENV['ESP_ENV'] = argv.first if argv.first && argv.first[0] != '-'
    end

    def write_help_message
      puts HELP_MESSAGE # rubocop:disable Rails/Output
    end

    def write_error_message(command)
      puts "Error: Command '#{command}' not recognized" # rubocop:disable Rails/Output
      write_help_message
      exit(1)
    end

    def parse_command(command)
      case command
      when '--version', '-v'
        'version'
      when '--help', '-h'
        'help'
      else
        command
      end
    end

    def print_banner
      begin
        puts File.read(File.expand_path(File.dirname(__FILE__) + '/../../../assets/esp_logo.ans')) # rubocop:disable Rails/Output
      rescue # rubocop:disable Lint/HandleExceptions
        # swallow the error
      end
      print <<-banner # rubocop:disable Rails/Output

      Evident Security Platform Console #{ESP::VERSION}
      Copyright (c) 2013-#{Time.current.year} Evident Security, All Rights Reserved.
      http://www.evident.io
      banner
    end
  end
end

# https://www.fedux.org/articles/2015/08/26/creating-an-irb-based-repl-console-for-your-project.html
require 'optparse'
require 'irb'

ARGV.clone.options do |opts|
  opts.banner = "Usage: esp console"

  opts.separator ""

  opts.on("-h", "--help",
          "Show this help message.") do
    puts opts # rubocop:disable Rails/Output
    exit
  end

  opts.separator ""
  opts.separator "An IRB console you can use if not using it in a Rails app"
  opts.separator ""

  opts.parse!
end

module ESP
  class Console
    # Start a console
    #
    # @return [void]
    def start # rubocop:disable Metrics/MethodLength
      ARGV.clear
      IRB.setup nil

      IRB.conf[:PROMPT]          = {}
      IRB.conf[:IRB_NAME]        = 'espsdk'
      IRB.conf[:PROMPT][:ESPSDK] = {
        PROMPT_I: '%N:%03n:%i> ',
        PROMPT_N: '%N:%03n:%i> ',
        PROMPT_S: '%N:%03n:%i%l ',
        PROMPT_C: '%N:%03n:%i* ',
        RETURN: "# => %s\n"
      }
      IRB.conf[:PROMPT_MODE] = :ESPSDK

      IRB.conf[:RC] = false

      require 'irb/completion'
      require 'irb/ext/save-history'
      IRB.conf[:READLINE]     = true
      IRB.conf[:SAVE_HISTORY] = 1000
      IRB.conf[:HISTORY_FILE] = '~/.esp_sdk_history'

      context = Class.new do
        include ESP
      end

      irb                     = IRB::Irb.new(IRB::WorkSpace.new(context.new))
      IRB.conf[:MAIN_CONTEXT] = irb.context

      trap("SIGINT") do
        irb.signal_handle
      end

      begin
        catch(:IRB_EXIT) do
          irb.eval_input
        end
      ensure
        IRB.irb_at_exit
      end
    end
  end
end

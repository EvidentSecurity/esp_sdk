require 'ansi/code'

module Minitest
  module Reporters
    # Features:
    #   Like the SpecReporter but with the pass/time on the left
    #   Collects the message before doing a puts so that lines dont get mixed up when running tests in threads
    #   Highlights lines in a stacktrace from this project
    #   Highlights slow tests
    class ParallelReporter < BaseReporter
      # fix coloring for parallel_tests
      require 'ansi/code'
      include ::ANSI::Code
      extend ::ANSI::Code

      include RelativePosition

      def report
        super
        msg = "\n"
        msg += "Finished in #{format('%f', total_time)}s"
        msg += "\n"
        msg += "#{format('%d', count)} tests, #{format('%d', assertions)} assertions, "
        color = failures.zero? && errors.zero? ? :green : :red
        msg += send(color) { "#{format('%d', failures)} failures, #{format('%d', errors)} errors, " }
        msg += yellow { "#{format('%d', skips)} skips" }
        msg += "\n"
        puts msg
      end

      def record(test)
        super
        if test.passed?
          print_pass(test)
        else
          print_fail(test)
        end
      end

      private

      def print_pass(_test)
        print green '.'
      end

      def print_fail(test)
        puts ''
        msg = ''
        msg += colored_status(test)
        msg += color_by_time(" (#{format('%.2f', test.time)}s)", test.time)
        msg += pad_test(test.name).gsub('test_: ', "[#{blue ENV['TEST_ENV_NUMBER'].to_i}] ")
        msg += stacktrace(test)
        puts msg
        puts ''
      end

      def color_by_time(string, time)
        if time > 5
          red string
        elsif time > 1
          yellow string
        else
          string
        end
      end

      def colored_status(test)
        if test.passed?
          green { pad_mark(result(test).to_s.upcase) }
        elsif test.skipped?
          yellow { pad_mark(result(test).to_s.upcase) }
        else
          red { pad_mark(result(test).to_s.upcase) }
        end
      end

      def stacktrace(test) # rubocop:disable Metrics/MethodLength
        return '' unless !test.skipped? && test.failure
        msg = "\n"
        msg += red(test.failure.message.split("\n    ").first.to_s) + "\n"
        test.failure.backtrace.each do |line|
          msg += if line.include?('esp_sdk/lib')
                   yellow line
                 else
                   line
                 end
          msg += "\n"
        end
        msg
      end
    end
  end
end

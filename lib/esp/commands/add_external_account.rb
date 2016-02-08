require 'optparse'

ARGV.clone.options do |opts|
  opts.banner = "Usage: esp add_external_account"

  opts.separator ""

  opts.on("-h", "--help",
          "Show this help message.") do
    puts opts # rubocop:disable Rails/Output
    exit
  end

  opts.separator ""
  opts.separator "Adds external accounts to ESP"
  opts.separator ""
  opts.separator "    NOTE: This program automatically generates new teams for every external account added. Some modifications may"
  opts.separator "    be required if you would like to organize accounts into specific teams. Please contact support@evident.io"
  opts.separator "    if you have any questions."
  opts.separator ""
  opts.separator "    AWS SDK for Ruby v2 required"
  opts.separator "      Install it by running `gem install aws-sdk`"
  opts.separator "      http://docs.aws.amazon.com/sdkforruby/api/"
  opts.separator ""
  opts.separator "    The AWS SDK for Ruby requires credentials to be set via environment variables, configuration file,"
  opts.separator "    or within the program. Also, you must set an AWS region for the SDK to communicate with the AWS"
  opts.separator "    service endpoints. It is recommended that you set environment variables before proceeding."
  opts.separator ""
  opts.separator "    Required variables:"
  opts.separator "      ENV['AWS_REGION']"
  opts.separator "      ENV['AWS_ACCESS_KEY_ID']"
  opts.separator "      ENV['AWS_SECRET_ACCESS_KEY']"
  opts.separator "      ENV['AWS_SESSION_TOKEN'] (if generating credentials using STS AssumeRole)"
  opts.separator ""
  opts.separator "    The ESP SDK for Ruby requires credentials to be set via environment variables or within the program."
  opts.separator "    It is recommended that you set environment variables before proceeding."
  opts.separator "    See the documentation for more information.  http://www.rubydoc.info/gems/esp_sdk/"
  opts.separator ""
  opts.separator "    Required variables:"
  opts.separator "      ENV['ESP_ACCESS_KEY_ID']"
  opts.separator "      ENV['ESP_SECRET_ACCESS_KEY']"
  opts.separator ""
  opts.separator "    Generate ESP keys at:"
  opts.separator "      https://esp.evident.io/settings/profile"
  opts.separator ""

  opts.parse!
end

begin
  external_account = ESP::ExternalAccountCreator.new.create
  puts "done on #{external_account.created_at}" # rubocop:disable Rails/Output
rescue ESP::AddExternalAccountError => e
  puts e.message.inspect # rubocop:disable Rails/Output
  puts e.backtrace # rubocop:disable Rails/Output
  exit e.exit_code
end

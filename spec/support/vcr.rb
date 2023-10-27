require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = File.expand_path('cassettes', __dir__)
  config.hook_into :faraday
  config.ignore_localhost = true
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<OPEN_WEATHER_API_KEY>') { ENV['OPEN_WEATHER_API_KEY'] }
end

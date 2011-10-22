ENV["RAILS_ENV"] ||= "test"

require 'rails_app/config/environment'
require_relative "../lib/chunks.rb"

silence_stream(STDOUT) { load "#{Rails.root.to_s}/db/schema.rb" }

require 'rspec/rails'
RSpec.configure do |config|
  config.mock_with :rspec
  config.include RSpec::Rails::ControllerExampleGroup, example_group: { file_path: /controllers/ }
end

require 'factory_girl'
Dir[File.join(File.dirname(__FILE__), "factories/**/*.rb")].each { |f| require f }
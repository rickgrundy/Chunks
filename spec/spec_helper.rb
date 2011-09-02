require 'rails_app/config/environment'
require File.expand_path("../../lib/chunks.rb", __FILE__)

silence_stream(STDOUT) { load "#{Rails.root.to_s}/db/schema.rb" }
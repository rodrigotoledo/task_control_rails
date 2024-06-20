# frozen_string_literal: true

require "factory_bot_rails"
require "simplecov"
require "shoulda/matchers"
require "stimulus_reflex_testing/rspec"
module ResponseHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ResponseHelpers, type: :request
end
SimpleCov.start "rails" do
  add_filter "vendor"
  add_filter "storage"
  add_filter "app/channels"
  add_filter "app/helpers"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/mailers/application_mailer.rb"
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

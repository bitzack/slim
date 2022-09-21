# spec/log_requests_middleware_spec.rb

require 'rails_helper'
require 'mocks/rack_app.rb'

RSpec.describe LogRequestsMiddleware do
    let(:app) { RackApp.new }
    subject { described_class.new(app) }
    
     context "Calling GET request with no JSON" do
          it "it throws a JSON::Parser exception" do
            env = Rack::MockRequest::env_for("http://localhost:3000")
            middleware = LogRequestsMiddleware.new(app)
            expect{middleware.call(env)}.to raise_exception(JSON::ParserError)
          end
        end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module LlmServiceTestHelper
  def with_llm_reply(reply)
    original = LlmService.method(:ask)
    LlmService.define_singleton_method(:ask) do |*|
      reply.respond_to?(:call) ? reply.call : reply
    end
    yield
  ensure
    LlmService.define_singleton_method(:ask, original)
  end
end

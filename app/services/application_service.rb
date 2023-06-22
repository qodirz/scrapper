require 'dry/monads/result'
require 'dry/matcher/result_matcher'

class ApplicationService
  extend Dry::Initializer

  include Dry::Monads[:result]

  def self.call(**args, &block)
    result = new(**args).call
    block_given? ? Dry::Matcher::ResultMatcher.call(result, &block) : result
  end

  def call
    raise 'Not Implemented'
  end
end

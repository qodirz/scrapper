module EHR
  class EHRService < ApplicationService
    option :client, type: Dry.Types.Instance(::Client)

    def self.call(**args, &block)
      result = new(**args).call(**args)

      block_given? ? Dry::Matcher::ResultMatcher.call(result, &block) : result
    end

    def call(**args, &block)
      if platform_class?
        platform_class.call(**args, &block)
      else
        Failure(platform_not_supported)
      end
    end

    private

    def platform
      client.platform.to_sym
    end

    def platform_class?
      platform_class.present?
    rescue NameError
      false
    end

    def platform_class
      self
        .class
        .name
        .gsub('EHR::', "EHR::#{platform.to_s.camelize}::")
        .constantize
    end

    def platform_not_supported
      "#{platform.to_s.titleize} is not supported by #{self.class.name}"
    end
  end
end

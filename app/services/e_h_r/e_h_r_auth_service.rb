module EHR
  class EHRAuthService < ApplicationService
    option :client, type: Dry.Types.Instance(::Client)
    option :skip_log_in, type: Dry::Types['bool'], default: proc { false }

    def self.call(**args, &block)
      configure_session(**args) do |service|
        result = service.call
        if block_given?
          Dry::Matcher::ResultMatcher.call(result, &block)
        else
          result
        end
      end
    end

    def self.configure_session(**args)
      service = new(**args)

      if args[:skip_log_in]
        yield(service)
      else
        EHR::BaseAdapter.transaction_session(service) do
          service.log_in

          result = yield(service)

          service.log_out

          result
        end
      end
    end

    def log_in
      credentials = {
        username: client.username,
        password: client.password
      }

      ehr_adapter_class_for('Auth').new.log_in(
        **credentials
      )
    end

    def log_out
      ehr_adapter_class_for('Auth').log_out
    end

    def platform
      client.platform.to_sym
    end

    def ehr_adapter_class_for(adapter)
      "EHR::#{platform.to_s.camelize}::#{adapter}".constantize
    end
  end
end

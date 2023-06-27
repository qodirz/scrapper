module EHR
  module Client
    class SyncClientJob < ApplicationJob
      def perform(client)
        EHR::Client::SyncClientService.call(client: client)
      rescue StandardError => e
        #retry_count = 0 if retry_count.nil?
        #if (retry_count += 1) < 3
          #retry
        #else
          raise e
        #end
      end
    end
  end
end

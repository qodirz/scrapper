module EHR
  module Client
    class SyncClientsService < EHRAuthService
      option :clients

      def call
        sync_clients
      end

      private

      def sync_clients
        clients.each do |client|
          SyncClientService.call(client: client)
        end
      end
    end
  end
end

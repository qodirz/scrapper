module EHR
  module Client
    class SyncClientService < EHRAuthService
      option :client, type: Dry.Types.Instance(::Client)

      def call
        sync_client_details

        Success(client)
      end

      private

      def sync_client_details
        client.assign_attributes(
          first_name: platform_client.first_name,
          last_name: platform_client.last_name,
          point: platform_client.point
        )

        ClientServices::UpdateClient.call(client: client)
      end

      def platform_client
        @platform_client ||=
          ehr_adapter_class_for('Client').profile
      end
    end
  end
end

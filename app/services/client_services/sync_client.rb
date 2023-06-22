module ClientServices
  class SyncClient < ApplicationService
    option :client, type: Dry.Types.Instance(Client)

    def call
      sync_with_emr(client)
      Success(client)
    end

    private

    def sync_with_emr(client)
      EHR::Client::SyncClientJob.perform_now(client)
      Success(client)
    end
  end
end

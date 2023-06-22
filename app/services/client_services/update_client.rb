module ClientServices
  class UpdateClient < ApplicationService
    option :client, type: Dry.Types.Instance(Client)

    def call
      update_client
    end

    private

    def update_client
      return Success(client) if client.save

      Failure(client)
    end
  end
end

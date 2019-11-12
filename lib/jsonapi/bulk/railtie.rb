require 'rails/railtie'

module JSONAPI
  module Bulk
    # @private
    class Railtie < ::Rails::Railtie
      initializer 'jsonapi-bulk.init' do |app|
        ActiveSupport.on_load(:action_controller) do
          require 'jsonapi/rails/controller/bulk_deserialization'
          include ::JSONAPI::Rails::Controller::BulkDeserialization
        end
      end
    end
  end
end

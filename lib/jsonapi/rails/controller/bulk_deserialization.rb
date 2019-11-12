require 'jsonapi/parser'
require 'jsonapi/parser/bulk'
require 'jsonapi/rails/deserializable_resource'
require 'jsonapi/rails/controller/deserialization'

module JSONAPI
  module Rails
    module Controller
      module BulkDeserialization
        extend ActiveSupport::Concern

        class_methods do
          def deserializable_resource(key, options = {}, &block)
            options = options.dup
            klass = options.delete(:class) ||
                    Class.new(JSONAPI::Rails::DeserializableResource, &block)
            bulk = options.delete(:bulk) || false

            before_action(options) do |controller|
              hash = controller.params.to_unsafe_hash.with_indifferent_access[:_jsonapi]
              if hash.nil?
                JSONAPI::Rails.logger.warn do
                  "Unable to deserialize #{key} because no JSON API payload was" \
                  " found. (#{controller.controller_name}##{params[:action]})"
                end
                next
              end

              ActiveSupport::Notifications
                .instrument('parse.jsonapi-rails',
                            key: key, payload: hash, class: klass) do
                if bulk && controller.request.headers['Content-Type'] =~ /;\s?ext=bulk\b/
                  JSONAPI::Parser::Bulk.parse!(hash)
                  resources = hash[:data].map { |data| klass.new(data) }
                  controller.request.env[JSONAPI::Rails::Controller::Deserialization::JSONAPI_POINTERS_KEY] = resources.first.reverse_mapping
                  controller.params[key.to_sym] = resources.map(&:to_hash)
                else
                  JSONAPI::Parser::Resource.parse!(hash)
                  resource = klass.new(hash[:data])
                  controller.request.env[JSONAPI::Rails::Controller::Deserialization::JSONAPI_POINTERS_KEY] = resource.reverse_mapping
                  controller.params[key.to_sym] = resource.to_hash
                end
              end
            end
          end
        end
      end
    end
  end
end

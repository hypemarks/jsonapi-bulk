require 'jsonapi/parser/document'

module JSONAPI
  module Parser
    class Bulk
      # Validate the structure of a bulk resource create/update payload.
      #
      # @param [Hash] document The input JSONAPI document.
      # @raise [JSONAPI::Parser::InvalidDocument] if document is invalid.
      def self.parse!(document)
        Document.ensure!(document.is_a?(Hash),
                         'A JSON object MUST be at the root of every JSONAPI ' \
                         'request and response containing data.')
        Document.ensure!(document.keys == ['data'].freeze &&
                         document['data'].is_a?(Array),
                         'The request MUST include an array of resource objects ' \
                         'as primary data.')
        document['data'].each { |data| Document.parse_primary_resource!(data) }
      end
    end
  end
end

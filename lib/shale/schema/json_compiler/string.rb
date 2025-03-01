# frozen_string_literal: true

module Shale
  module Schema
    class JSONCompiler
      # Class that maps Schema type to Shale String type
      #
      # @api private
      class String
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::String'
        end
      end
    end
  end
end

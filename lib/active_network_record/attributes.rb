require 'active_support/core_ext/hash/indifferent_access'

module ActiveNetworkRecord
  module Attributes
    def initialize(attributes = {})
      @attributes = filter_attributes attributes
      @dirty = false
    end

    def filter_attributes(attributes)
      attributes.with_indifferent_access.select do |(key, _value)|
        self.class.attributes.include? key.to_sym
      end
    end

    def attributes
      @attributes ||= {}
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def attributes
        @attributes ||= []
      end

      def attributes=(values = [])
        @attributes = values
      end
    end
  end
end

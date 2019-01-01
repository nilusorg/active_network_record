require 'active_support/core_ext/hash/indifferent_access'

module ActiveNetworkRecord
  module Attributes
    def initialize(attributes = {})
      @attributes = filter_attributes attributes
      @dirty = false
    end

    def attributes
      @attributes ||= {}
    end

    def dirty
      @dirty ||= false
    end

    def dirty!
      @dirty = true
    end

    def write_attribute(key, value)
      raise ArgumentError, "The attribute #{key} isn't one of the attributes list(#{self.class.attributes})" unless self.class.attributes.include? key.to_sym # rubocop:disable Metrics/LineLength

      dirty!
      @attributes[key] = value
    end

    def read_attribute(key)
      @attributes[key]
    end

    def assign_attributes(attributes = {})
      attributes.each do |(key, value)|
        write_attribute key, value
      end
    end

    def as_json
      attributes
    end

    alias dirty? dirty

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    private

    def filter_attributes(attributes)
      attributes.with_indifferent_access.select do |(key, _value)|
        self.class.attributes.include? key.to_sym
      end
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

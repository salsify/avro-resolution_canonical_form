# frozen_string_literal: true

module Avro
  class ResolutionCanonicalForm < Avro::SchemaNormalization
    DECIMAL_LOGICAL_TYPE = 'decimal'

    def self.to_resolution_form(schema)
      new.to_resolution_form(schema)
    end

    def to_resolution_form(schema)
      MultiJson.dump(normalize_schema(schema))
    end

    private

    def normalize_schema(schema)
      if schema.type_sym == :bytes && schema.logical_type == DECIMAL_LOGICAL_TYPE
        add_logical_type(schema, type: schema.type)
      else
        super
      end
    end

    def normalize_field(field)
      extensions = {}
      extensions[:default] = field.default if field.default?
      extensions[:aliases] = field.aliases.sort if field.aliases && !field.aliases.empty?

      super.merge(extensions)
    end

    def add_logical_type(schema, serialized)
      if schema.logical_type == DECIMAL_LOGICAL_TYPE
        extensions = { logicalType: DECIMAL_LOGICAL_TYPE }
        extensions[:precision] = schema.precision if schema.respond_to?(:precision) && schema.precision
        extensions[:scale] = schema.scale if schema.respond_to?(:scale) && schema.scale
        serialized.merge(extensions)
      else
        serialized
      end
    end

    def normalize_named_type(schema, attributes = {})
      extensions = {}
      if schema.respond_to?(:default) && !schema.default.nil?
        # For enum defaults
        extensions[:default] = schema.default
      end

      aliases = schema.fullname_aliases
      extensions[:aliases] = aliases.sort unless aliases.empty?
      extensions = add_logical_type(schema, extensions)
      super.merge(extensions)
    end
  end
end

require 'avro-patches'

module Avro
  class ResolutionCanonicalForm < SchemaNormalization
    def self.to_resolution_form(schema)
      new.to_resolution_form(schema)
    end

    def to_resolution_form(schema)
      MultiJson.dump(normalize_schema(schema))
    end

    private

    # TODO: include aliases once the avro Ruby gem supports them
    # Note: permitted values for defaults are not enforced here.
    # That should be done at the schema level, and is not done currently
    # in the Avro Ruby gem
    def normalize_field(field)
      default_value = if field.default?
                        { default: field.default }
                      else
                        {}
                      end
      super.merge(default_value)
    end

    # TODO: Override normalize_named_type once the Avro Ruby gem supports aliases
    # def normalized_named_type(schema, attributes = {})
  end
end

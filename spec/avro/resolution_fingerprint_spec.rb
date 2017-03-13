describe Avro::Schema, "#sha256_resolution_fingerprint" do
  describe "#sha256_resolution_fingerprint" do
    let(:fingerprint) { schema.sha256_resolution_fingerprint }

    shared_examples_for "a fingerprint based on the resolution canonical form" do
      it "returns the fingerprint" do
        expect(fingerprint).to eq(expected)
      end
    end

    context "a primitive" do
      let(:schema) do
        Avro::Schema.parse <<-SCHEMA
          { "type": "int" }
        SCHEMA
      end
      let(:expected) do
        # No different from Parsing Canonical Form fingerprint
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "a record" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "record",
            "name": "test",
            "namespace": "random",
            "doc": "some record",
            "fields": [
              { "name": "height", "type": "int", "default": 1, "doc": "the height" },
              { "name": "width", "type": "int", "doc": "the width" }
            ]
          }
        JSON
      end
      let(:expected) do
        76215121346273769907599941410596079616301682207627952515775291450295463500031
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"

      it "differs from the parsing fingerprint" do
        expect(schema.sha256_fingerprint).not_to eq(expected)
      end
    end


    context "a record with a field with an alias" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "record",
            "name": "test",
            "namespace": "random",
            "doc": "some record",
            "fields": [
              {
                "name": "height",
                "type": "int",
                "aliases": ["vertical", "how.tall"],
                "doc": "the height" }
            ]
          }
        JSON
      end
      let(:expected) do
        # This is expected to change if alias support is added
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "a record with an alias" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "record",
            "name": "test",
            "aliases": ["resolution.test", "example"],
            "namespace": "random",
            "doc": "some record",
            "fields": [
              { "name": "width", "type": "int", "doc": "the width" }
            ]
          }
        JSON
      end
      let(:expected) do
        # This is expected to change if alias support is added
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "an enum type" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "enum",
            "name": "suit",
            "aliase": ["family"],
            "namespace": "cards",
            "doc": "the different suits of cards",
            "symbols": ["club", "hearts", "diamond", "spades"]
          }
        JSON
      end
      let(:expected) do
        # This is expected to change if alias support is added
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "a fixed type" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "fixed",
            "name": "id",
            "aliases": ["identifier", "internal.id"],
            "namespace": "db",
            "size": 64
          }
        JSON
      end
      let(:expected) do
        # This is expected to change if alias support is added
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end
  end
end

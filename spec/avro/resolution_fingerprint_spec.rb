describe Avro::Schema, "#sha256_resolution_fingerprint" do
  describe "#sha256_resolution_fingerprint" do
    let(:fingerprint) { schema.sha256_resolution_fingerprint }

    shared_examples_for "a fingerprint based on the resolution canonical form" do
      it "returns the fingerprint" do
        expect(fingerprint).to eq(expected)
      end
    end

    shared_examples_for "a fingerprint that differs from parsing canonical form" do
      it "returns the fingerprint" do
        expect(fingerprint).not_to eq(schema.sha256_fingerprint)
      end
    end

    context "a primitive" do
      let(:schema) do
        Avro::Schema.parse <<-SCHEMA
          { "type": "int" }
        SCHEMA
      end
      let(:expected) do
        # No difference from Parsing Canonical Form fingerprint
        schema.sha256_fingerprint
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "bytes with decimal logical type" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "bytes",
            "logicalType": "decimal",
            "precision": 4,
            "scale": 2
          }
        JSON
      end

      let(:expected) do
        43426978718629271103217491481906353617743628111159770510613790541912847774184
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
      it_behaves_like "a fingerprint that differs from parsing canonical form"
    end

    context "bytes with decimal logical type and only precision" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "bytes",
            "logicalType": "decimal",
            "precision": 4
          }
        JSON
      end

      let(:expected) do
        12802922089401264000746941315799739654898256907199367681849125434025528903374
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
      it_behaves_like "a fingerprint that differs from parsing canonical form"
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
        41824580905639955713912383523901481096154542298417736906857707278253262501123
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
        75464744640852001426996643166120064129197712472970600732646526647284533479704
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "an enum type" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "enum",
            "name": "suit",
            "aliases": ["family"],
            "namespace": "cards",
            "doc": "the different suits of cards",
            "symbols": ["club", "hearts", "diamond", "spades"]
          }
        JSON
      end
      let(:expected) do
        61020363212270409218377207099557595293985490295392385899935597230071562257837
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "an enum type with a default" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "enum",
            "name": "suit",
            "aliases": ["family"],
            "namespace": "cards",
            "doc": "the different suits of cards",
            "symbols": ["club", "hearts", "diamond", "spades"],
            "default": "diamond"
          }
        JSON
      end
      let(:expected) do
        63531828704047373383544513449830771947491531187791621354409622739327366772267
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
        45487341757747564218800088807604506579998219041491597587640008023295720141043
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end

    context "fixed type with decimal logical type" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "fixed",
            "name": "my_decimal",
            "aliases": ["precise", "number.logical"],
            "namespace": "logical",
            "size": 10,
            "logicalType": "decimal",
            "precision": 8,
            "scale": 2
          }
        JSON
      end

      let(:expected) do
        # This is expected to change to the decimal logical type is fully supported for fixed in Avro Ruby
        109010719941921900671474271265982157895832083260603382288605526885391235302023
      end

      it_behaves_like "a fingerprint based on the resolution canonical form"
    end
  end
end

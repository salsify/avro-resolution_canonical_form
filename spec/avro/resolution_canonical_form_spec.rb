# frozen_string_literal: true

describe Avro::ResolutionCanonicalForm do
  let(:resolution_form) { described_class.to_resolution_form(schema) }

  describe ".to_resolution_form" do
    context "primitive types" do
      ['null', 'boolean', 'string', 'bytes', 'int', 'long', 'float', 'double'].each do |type|
        it "returns the resolution canonical form for '#{type}'" do
          schema = Avro::Schema.parse(<<-JSON)
            { "type": "#{type}" }
          JSON
          expect(described_class.to_resolution_form(schema)).to eq(%("#{type}"))
        end
      end
    end

    shared_examples_for "resolution normalization" do
      it "returns the resolution canonical form" do
        expect(resolution_form).to eq(expected_type)
      end
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

      let(:expected_type) do
        <<-JSON.strip
          {"type":"bytes","logicalType":"decimal","precision":4,"scale":2}
        JSON
      end

      it_behaves_like "resolution normalization"
    end

    context "bytes with decimal logical type and only precision" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "bytes",
            "logicalType": "decimal",
            "precision": 5
          }
        JSON
      end

      let(:expected_type) do
        <<-JSON.strip
          {"type":"bytes","logicalType":"decimal","precision":5}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        <<-JSON.strip
          {"name":"random.test","type":"record","fields":[{"name":"height","type":"int","default":1},{"name":"width","type":"int"}]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
                "default": 1,
                "doc": "the height" }
            ]
          }
        JSON
      end
      let(:expected_type) do
        <<-JSON.strip
          {"name":"random.test","type":"record","fields":[{"name":"height","type":"int","default":1,"aliases":["how.tall","vertical"]}]}
        JSON
      end

      it_behaves_like "resolution normalization"
    end

    context "recursive records" do
      let(:schema) do
        Avro::Schema.parse(<<-JSON)
          {
            "type": "record",
            "name": "item",
            "fields": [
              { "name": "next", "type": "item" }
            ]
          }
        JSON
      end
      let(:expected_type) do
        <<-JSON.strip
          {"name":"item","type":"record","fields":[{"name":"next","type":"item"}]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        <<-JSON.strip
          {"name":"random.test","type":"record","fields":[{"name":"width","type":"int"}],"aliases":["random.example","resolution.test"]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        <<-JSON.strip
          {"name":"cards.suit","type":"enum","symbols":["club","hearts","diamond","spades"],"aliases":["cards.family"]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        <<-JSON.strip
          {"name":"cards.suit","type":"enum","symbols":["club","hearts","diamond","spades"],"default":"diamond","aliases":["cards.family"]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        <<-JSON.strip
          {"name":"db.id","type":"fixed","size":64,"aliases":["db.identifier","internal.id"]}
        JSON
      end

      it_behaves_like "resolution normalization"
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
      let(:expected_type) do
        # This is expected to change to the decimal logical type is fully supported for fixed in Avro Ruby
        <<-JSON.strip
          {"name":"logical.my_decimal","type":"fixed","size":10,"aliases":["logical.precise","number.logical"],"logicalType":"decimal"}
        JSON
      end

      it_behaves_like "resolution normalization"
    end
  end
end

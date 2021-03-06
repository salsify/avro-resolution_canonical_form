# avro-resolution_canonical_form

This gem defines a [Resolution Canonical Form](#resolution_canonical_form) for Avro schemas.
This is similar to the [Parsing Canonical Form](http://avro.apache.org/docs/1.8.1/spec.html#Parsing+Canonical+Form+for+Schemas)
from the Apache Avro spec, but extends is to also include attributes that are
relevant to schema resolution and compatibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avro-resolution_canonical_form'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avro-resolution_canonical_form

## Resolution Canonical Form

The Resolution Canonical Form extends the [Parsing Canonical Form](http://avro.apache.org/docs/1.10.0/spec.html#Parsing+Canonical+Form+for+Schemas)
to include `default` and `aliases` attributes and logical type for decimals:

* [STRIP] Keep only attributes that are relevant to resolution, which are:
  `name, type, fields, symbols, items, values, size, default, aliases, logical_type(=decimal), precision, scale`
* [ORDER] Order the appearance of fields in JSON objects as follows:
  `name, type, fields, symbols, items, values, size, default, aliases`
* [ALIASES] [Aliases](http://avro.apache.org/docs/1.10.0/spec.html#Aliases) for
  named types and fields are converted to their fullname, using applicable
  namespace, and sorted.

## Usage

`Avro::ResolutionCanonicalForm` subclasses `Avro::SchemaNormalization`
and provides a `to_resolution_form` method that returns the resolution canonical
form for the schema:

```ruby
require 'avro-resolution_canonical_form'

schema = Avro::Schema.parse(<<-JSON)
  {
    "type": "record",
    "name": "dimensions",
    "aliases": ["dims", "eg.sizing"],
    "namespace": "example",
    "doc": "an example",
    "fields": [
      { "name": "height", "type": "int", "default": 1, "doc": "the height" },
      { "name": "width", "aliases": ["across"], "type": "int", "doc": "the width" }
    ]
  }
JSON

Avro::ResolutionCanonicalForm.to_resolution_form(schema)
#=> => "{\"name\":\"example.dimensions\",\"type\":\"record\",\"fields\":[{\"name\":\"height\",\"type\":\"int\",\"default\":1},{\"name\":\"width\",\"type\":\"int\",\"aliases\":[\"across\"]}],\"aliases\":[\"eg.sizing\",\"example.dims\"]}"
```

A new method, `#sha256_resolution_fingerprint`, is added to `Avro::Schema` to
return the SHA256 digest based on the resolution form above. This is similar to
the existing `#sha256_fingerprint` which is based on the Parsing Canonical Form.

```ruby
schema.sha256_resolution_fingerprint

#=> 71676413924523555041213790831440929350080614901361467355865523343334332562796
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org)
.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/salsify/avro-resolution_canonical_form.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).


# avro-resolution_canonical_form

## v0.6.0
- Add support for Ruby 3.2.
- Drop support for Ruby 2.6.

## v0.5.0
- Require Avro v1.11.

## v0.4.0
- Drop dependency on `avro-patches`.
- Add support for Ruby 3.0.
- Drop support for Ruby < 2.6.
- Use frozen string literals.

## v0.3.0
- Require Avro v1.10.
- Include aliases, enum defaults, and decimal logical types in the resolution
  canonical form. Schemas that use any of these parts of the Avro spec will
  get a different fingerprint with this version.

## v0.2.1
- Restrict to `avro-patches` versions < 2.0.0.

## v0.2.0
- Require `avro-patches` instead of `avro-salsify-fork`.

## v0.1.0
- Initial version

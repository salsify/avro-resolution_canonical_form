# frozen_string_literal: true

module Avro
  class Schema
    # Returns the SHA-256 fingerprint of the Resolution Canonical Form for the
    # schema as an Integer
    def sha256_resolution_fingerprint
      resolution_form = ResolutionCanonicalForm.to_resolution_form(self)
      Digest::SHA256.hexdigest(resolution_form).to_i(16)
    end
  end
end

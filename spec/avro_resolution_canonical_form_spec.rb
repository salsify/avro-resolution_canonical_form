require 'spec_helper'

describe Avro::ResolutionCanonicalForm, 'VERSION' do
  it "has a version number" do
    expect(Avro::ResolutionCanonicalForm::VERSION).not_to be nil
  end
end

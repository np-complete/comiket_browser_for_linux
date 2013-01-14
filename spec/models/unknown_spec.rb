require 'spec_helper'

describe "Unknown Model" do
  let(:unknown) { Unknown.new }
  it 'can be created' do
    unknown.should_not be_nil
  end
end

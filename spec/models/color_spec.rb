require 'spec_helper'

describe "Color Model" do
  let(:color) { FactoryGirl.create(:color) }
  it 'can be created' do
    color.should_not be_nil
  end
end

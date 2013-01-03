require 'spec_helper'

describe "Block Model" do
  let(:block) { FactoryGirl.create(:block) }

  it 'can be created' do
    block.should_not be_nil
  end
end

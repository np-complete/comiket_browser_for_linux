require 'spec_helper'

describe "Block Model" do
  let(:block) { Block.new }
  it 'can be created' do
    block.should_not be_nil
  end
end

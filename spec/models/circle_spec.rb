require 'spec_helper'

describe Circle do
  let(:circle) { FactoryGirl.create(:circle) }
  it 'can be created' do
    circle.should_not be_nil
  end
end

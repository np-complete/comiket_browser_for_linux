require 'spec_helper'

describe Circle do
  let(:circle) { Circle.new }
  it 'can be created' do
    circle.should_not be_nil
  end
end

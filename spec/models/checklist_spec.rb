require 'spec_helper'

describe Checklist do
  let(:checklist) { Checklist.new }
  it 'can be created' do
    checklist.should_not be_nil
  end
end

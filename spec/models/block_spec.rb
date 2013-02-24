require 'spec_helper'

describe "Block Model" do
  let(:block) { FactoryGirl.create(:block, :day => 1) }

  describe :accessor do
    before { FactoryGirl.create_list(:circle, 60, day: 1, block: block) }

    subject { block }
    its(:day) { should == 1 }
    its(:pages) { should == 4 }
  end

  describe :connections do
    subject { blocks[2] }
    let(:blocks) { FactoryGirl.create_list(:block, 5) }
    let!(:circles) do
      [0, 1, 2, 3, 4].map do |i|
        FactoryGirl.create(:circle, block: blocks[i], day: 1)
        FactoryGirl.create(:circle, block: blocks[i], day: 2) if i.even?
      end
    end

    context :last_block do
      subject { blocks[4] }
      its(:next_block) { should == nil }
    end

    context :first_block do
      subject { blocks[0] }
      its(:prev_block) { should == nil }
    end

    context :not_skipped_block do
      before { blocks[2].day = 1 }
      its(:prev_block) { should == blocks[1] }
      its(:next_block) { should == blocks[3] }
    end

    context :skipped_block do
      before { blocks[2].day = 2 }
      its(:prev_block) { should == blocks[0] }
      its(:next_block) { should == blocks[4] }
    end
  end
end

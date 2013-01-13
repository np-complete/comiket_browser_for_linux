require 'spec_helper'

describe "Block Model" do
  let(:block) { FactoryGirl.create(:block, :day => 1) }

  describe :accessor do
    subject { block }
    its(:day) { should == 1 }
  end

  describe :connections do
    let(:blocks) { FactoryGirl.create_list(:block, 5) }
    let!(:circles) do
      [0, 1, 2, 3, 4].map do |i|
        FactoryGirl.create(:circle, block: blocks[i], day: 1)
        FactoryGirl.create(:circle, block: blocks[i], day: 2) if i.even?
      end
    end

    context :last_block do
      subject { blocks[4] }
      its(:next_block_id) { should == nil }
    end

    context :first_block do
      its(:prev_block_id) { should == nil }
    end

    subject { blocks[2] }
    context :day_1 do
      before { blocks[2].day = 1 }
      its(:prev_block_id) { should == blocks[1].id }
      its(:next_block_id) { should == blocks[3].id }
    end

    context :day_2 do
      before { blocks[2].day = 2 }
      its(:prev_block_id) { should == blocks[0].id }
      its(:next_block_id) { should == blocks[4].id }
    end
  end
end

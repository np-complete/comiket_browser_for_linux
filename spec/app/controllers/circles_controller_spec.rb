require 'spec_helper'

describe "CirclesController" do
  let!(:old_blocks) { FactoryGirl.create_list(:block, 5, :old) }
  let!(:blocks) { FactoryGirl.create_list(:block, 5) }
  let!(:circles) do
    Hash[[0, 2].map do |i|
      [i, FactoryGirl.create_list(:circle, 60, block: blocks[i])]
    end]
  end

  subject { Hashr.new JSON.parse(last_response.body) }
  context :default_condition do
    before { get "/circles" }

    its(:info) { should == {block: blocks.first.name, day: 1} }
    its(:cond) do
      should == {
        :next => {page: 1, day: 1},
        :prev => nil
      }
    end
  end

  context :page_1 do
    before { get "/circles", page: 1 }

    its(:cond) do
      should == {
        :next => {page: 2, day: 1},
        :prev => {page: 0, day: 1}
      }
    end
  end

  context :block_id_given do
    context :normal do
      before { get "/circles", page: 1, block_id: blocks[2].id }
      its(:cond) do
        should == {
          :prev => {page: 0, day: 1, block_id: blocks[2].id},
          :next => {page: 2, day: 1, block_id: blocks[2].id}
        }
      end
    end

    context :other_prev_block do
      before { get "/circles", page: 0, block_id: blocks[2].id }
      its(:cond) do
        should == {
          :prev => {page: 3, day: 1, block_id: blocks[0].id},
          :next => {page: 1, day: 1, block_id: blocks[2].id}
        }
      end
    end

    context :other_next_block do
      before { get "/circles", page: 3, block_id: blocks[0].id }
      its(:cond) do
        should == {
          :prev => {page: 2, day: 1, block_id: blocks[0].id},
          :next => {page: 0, day: 1, block_id: blocks[2].id}
        }
      end
    end
  end

  context :invalid_parameter do
    subject { last_response }
    before { get "/circles", page: -1 }
    its(:status) { should == 400 }
  end

end

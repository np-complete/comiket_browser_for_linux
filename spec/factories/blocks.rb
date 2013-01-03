FactoryGirl.define do
  factory :block do
    comiket_no Comiket::No
    sequence(:name) { |n| "A" + n.to_s }
  end
end

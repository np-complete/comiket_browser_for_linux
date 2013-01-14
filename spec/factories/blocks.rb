FactoryGirl.define do
  factory :block do
    comiket_no Comiket::No
    sequence(:name) { |n| "A" + n.to_s }

    trait :old do
      comiket_no Comiket::No - 1
    end
  end
end

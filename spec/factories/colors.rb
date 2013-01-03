FactoryGirl.define do
  factory :color do
    sequence(:title) { |n| "color#{n}" }
    sequence(:color) { |n| "ffcc%02x" % n }
  end
end

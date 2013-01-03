FactoryGirl.define do
  factory :circle do
    sequence(:circle_id)
    comiket_no Comiket::No
    day 1
    block
    sequence(:space_no) { |n| ((n - 1) % 60) + 1 }
    sequence(:name) { |n| "name_#{n}" }
    sequence(:name_kana) { |n| "name_kana_#{n}" }
    sequence(:author) { |n| "author_#{n}" }
    book "unko"
    cut_index 1
    genre_code 1
    page 1
  end
end

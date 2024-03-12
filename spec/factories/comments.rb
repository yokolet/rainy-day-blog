FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    user { nil }
    post { nil }
  end
end

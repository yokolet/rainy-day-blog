FactoryBot.define do
  factory :user do
    identifier { Faker::Internet.username(specifier: 5..10) }
    name { Faker::Name.name }
    provider { [0, 1, 2].sample }
  end
end

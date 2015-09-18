Fabricator(:video) do
  title { sequence(:title) { |i| Faker::Lorem.word + " #{i}" } }
  description { Faker::Lorem.paragraph }
  category { Fabricate(:category) }
end
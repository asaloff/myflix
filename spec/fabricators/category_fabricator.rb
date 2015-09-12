Fabricator(:category) do
  title { sequence(:title) { |i| Faker::Lorem.word + " #{i}" } }
end
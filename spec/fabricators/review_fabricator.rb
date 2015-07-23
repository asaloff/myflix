Fabricator(:review) do
  rating { (1..5).to_a.sample }
  content { Faker::Lorem.paragraph(5) }
  user_id { Fabricate(:user).id }
end
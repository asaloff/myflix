Fabricator(:user) do
  email { sequence(:email) { |i| Faker::Internet.email + "#{i}" } }
  password { 'password' }
  full_name { sequence(:full_name) { |i| Faker::Name.name + " #{i}" } }
end
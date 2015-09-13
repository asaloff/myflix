Fabricator(:invitation) do
  invitee_name { sequence(:invitee_name) { |i| Faker::Name.name + " #{i}" } }
  invitee_email { sequence(:invitee_email) { |i| Faker::Internet.email + " #{i}" } }
  message { Faker::Lorem.paragraph(2) }
end
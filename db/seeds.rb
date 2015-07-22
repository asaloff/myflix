# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(full_name: 'Aaron Saloff', email: 'aaronsaloff@example.com', password: 'password')
Category.create(title: "Comedy")
Category.create(title: "Cartoons")
Video.create(title: "Monk", description: "After the unsolved murder of his wife, Adrian Monk develops obsessive-compulsive disorder, which includes his terror of germs and contamination. His condition costs him his job as a prominent homicide detective in the San Francisco Police Department, but he continues to solve crimes with the help of his assistant and his former boss.", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future. He is taken in by his sole descendant, an elderly and addled scientist who owns a small cargo delivery service. Among the other crew members are Capt. Leela, accountant Hermes, intern Amy, obnoxious robot Bender and lobsterlike moocher 'Dr.' Zoidberg.", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
3.times { Fabricate(:review, video: Video.first) }

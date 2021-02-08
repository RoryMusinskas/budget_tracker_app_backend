# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Seeding categories....."
Category.create(description:"grocery")
Category.create(description:"travel")
Category.create(description:"entertainment")
Category.create(description:"necessity")
Category.create(description:"others")
Category.create(description:"wages")
Category.create(description:"shares")
Category.create(description:"interest")
Category.create(description:"investment")
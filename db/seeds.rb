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

puts 'Seeding fake testing user data'

puts 'seeding fake expenses'
Expense.create(description: 'Safeway Shopping', amount: 150, category_id: 1, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Shopping', date: '01/02/2021')
Expense.create(description: 'T-shirts from target', amount: 50, category_id: 4, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Clothes', date: '02/02/2021')
Expense.create(description: 'Computer mouse', amount: 100, category_id: 3, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Computer Mouse', date: '04/02/2021')
Expense.create(description: 'Screen protector for laptop', amount: 30, category_id: 4, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Screen protector', date: '05/02/2021')
Expense.create(description: 'Sony noise cancelling headphones', amount: 300, category_id: 5, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Sony Headphones', date: '06/02/2021')

puts 'seeding fake incomes'
Income.create(description: 'Wage from work', amount: 1500, category_id: 6, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Wage', date: '01/02/2021')
Income.create(description: 'Profit off the DogeCoin', amount: 500, category_id: 7, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Share Profit', date: '02/02/2021')
Income.create(description: 'Interest from bank', amount: 10, category_id: 8, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Bank Interest', date: '04/02/2021')
Income.create(description: 'Investment property growth', amount: 300, category_id: 9, user_sub: Rails.application.credentials.auth0[:fake_user_sub], title: 'Investment Property', date: '05/02/2021')

puts 'seeding fake share watchlist'
Share.create(description: "DOMINO'S PIZZA ENTERPRISES L", symbol: 'ASX:DMP', user_sub: Rails.application.credentials.auth0[:fake_user_sub])
Share.create(description: 'VANGUARD DIVFY HIGRO IDX ETF', symbol: 'ASX:VDHG', user_sub: Rails.application.credentials.auth0[:fake_user_sub])
Share.create(description: 'TPG TELECOM LTD', symbol: 'ASX:TPG', user_sub: Rails.application.credentials.auth0[:fake_user_sub])
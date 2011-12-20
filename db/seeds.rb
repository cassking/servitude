# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'user@weblinc.com', password: 'a_password')

Task.create(name: 'One Task')
Task.create(name: 'Two Task')
Task.create(name: 'Red Task')
Task.create(name: 'Blue Task')

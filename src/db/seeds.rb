# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Create CD'
CompactDisk.create! :user_id => 1, :title => "13", :artist=> "Die Ärzte", :genre => "Punk"

puts 'Create Roles'
Role.create! :role => "user"
Role.create! :role => "admin"
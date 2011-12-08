# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Create Roles'
Role.create! :role => "user"
Role.create! :role => "admin"

#puts 'Create User'
User.create! :role_id => 1, :lastname => "Bunk", :firstname=> "Christian", :email => "christianb@gmail.com", :password => "qwertz"
#admin = User.create! :role_id => 2, :lastname => "Admin", :firstname=> "Ein", :email => "admin@admin.de", :image_uri => "admin.png", :password => "adminadmin"

#admin.update_attribute(:role_id, 2)

#puts 'Create CD'
#CompactDisk.create! :user_id => 1, :title => "13", :artist=> "Die Aerzte", :genre => "Punk"


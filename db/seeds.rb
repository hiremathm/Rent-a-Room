# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Role.create(name: "admin")
Role.create(name: "host")
Role.create(name: "guest")

User.create(email: "admin@gmail.com", password: "shivam", mobile: "9731937369", first_name: "admin", last_name: "admin", username: "admin", role_id: Role.find_by(name: "admin").id)

User.create(email: "shivasorab@gmail.com", password:"shivam", mobile: "9743904397", first_name: "shiva", 
	last_name: "m", username: "shiva", role_id: Role.find_by(name: "host").id)

User.create(email: "yourmail4shiva@gmail.com", password:"shivam", mobile: "9456231245", first_name: "ani", last_name: "m", username: "ani", role_id: Role.find_by(name: "guest").id)

User.create(email: "shashisorab@hotmail.com", password:"shivam", mobile: "9731737369", first_name: "shashi", last_name: "m", username: "shashi", role_id: Role.find_by(name: "guest").id)

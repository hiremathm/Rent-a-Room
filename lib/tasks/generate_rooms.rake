namespace :generate_rooms do 
	desc "Generate Fake Rooms"
	task :import_rooms => :environment do 
		record = []
		100.times do 
  			state_id = Random.rand(35)
  			city_id = City.where(state_code: state_id).map(&:id).sample
  			house_type = ['single_room','1 bhk','2 bhk','3 bhk','4 bhk'].sample
  			house_plan = ['rent','sale','lease'].sample
  			name = Faker::Company.name
  			record << Room.new(name: name, description: Faker::Lorem.paragraph, price: Random.rand(5000), rules: Faker::Lorem.paragraph, address: Faker::Address.full_address, images: nil, latitude: nil, longitude: nil , city_id: city_id, user_id: 2, is_authorized: false, slug: name, state_id: state_id, house_type: house_type, house_plan: house_plan)
		end
		Room.import record
	end
end
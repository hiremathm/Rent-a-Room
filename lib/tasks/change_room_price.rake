namespace :change_room_price do
	desc "Change room price for every two days"
	task :change_price => :environment do 
		Room.all.each do |room|
			room.special_prices.destroy_all if room.special_prices.present?
			discount = Random.rand(20)
			discount_price = room.price * discount / 100 
			special_price = room.price - discount_price 
			room.special_prices.create(start_date: Date.today, end_date: Date.today + 2, price: special_price, discount: discount)
		end
	end
end

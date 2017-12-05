30.times do
c = City.new
c.name = Faker::Address.city
c.save
end

10.times do
c = Amenity.new
c.name = Faker::Book.title
c.description = Faker::Coffee.notes
c.save
end

	def calculate_room_price
		self.price = (self.start_date..self.end_date).count * self.room.price
	end 
	# def calculate_room_price
	# 	special_booking = SpecialPrice.where('room_id =?', self.room_id)
	# 	binding.pry
	# 	price = []
	# 	dates = (self.start_date..self.end_date).to_a
	# 	binding.pry
	# 	special_booking.each do |booking|
	# 		special_booking_dates = (booking.start_date..booking.end_date).to_a

	# 		binding.pry
	# 		if !(dates&special_booking_dates).empty?
	# 			special_booking_price = booking.price
	# 			binding.pry
	# 			price << ((dates&special_booking_dates).length * special_booking_price)
	# 			dates -= special_booking_dates
	# 			binding.pry
	# 		end
	# 	end
	# 	binding.pry
	# 	if price.empty?
	# 		special_day_cost = 0
	# 		binding.pry
		
	# 	else
	# 		special_day_cost = price.inject(:+)
	# 		binding.pry
		
	# 	end
	# 	normal_day_cost = self.room.price.to_i * (dates.length)
	# 	binding.pry
		
	# 	self.price = (special_day_cost + normal_day_cost)	
	# 	binding.pry
	#  end
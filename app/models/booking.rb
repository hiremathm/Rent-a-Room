class Booking < ActiveRecord::Base
	before_validation :calculate_room_price
	belongs_to :user
	belongs_to :room

	validates_presence_of :start_date, :end_date, :price, :room_id, :user_id
	validate :validate_dates, on: :create
	validate :check_date_availablity, on: :create	
	# validate :calculate_room_price, on: :create

	def check_date_availablity
		current_booking = (self.start_date..self.end_date).to_a
		previous_bookings = Booking.where('room_id =?', self.room_id)
		previous_bookings.each do |booking|
			previous_booking_date = (booking.start_date..booking.end_date).to_a
			current_booking.each do |booking|
				if previous_booking_date.include?(booking)	
					self.errors.add(:base, "This room is already booked for the below dates ")		
					break
				end
			end
		end
	end
	
	def validate_dates
		if self.start_date < Date.today
			self.errors.add(:base,"Start date cannot be less than Today Date........ ")
		elsif(self.end_date < self.start_date)
			self.errors.add(:base,"End date cannot be less than Start Date........")
		end
	end
	def calculate_room_price
	total = 0
	count = 0
	current_booking = (self.start_date..self.end_date).to_a
		self.room.special_prices.each do |special_price|
			if special_price.room_id == self.room_id
				dates = ((special_price.start_date..special_price.end_date)).to_a
				dates.each do |date|
					if current_booking.include?date
						total += special_price.price
						count +=1 
					end
				end
			end
		end
		count = current_booking.length - count
		total = total + self.room.price * count
		self.price = total 
	 end
end
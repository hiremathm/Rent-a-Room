class Booking < ActiveRecord::Base

	#after_update :booking_confirmed
	#after_create :booking_confirmation
	
	before_validation :calculate_room_price
	
	belongs_to :user
	belongs_to :room

	validates_presence_of :start_date, :end_date, :price, :room_id, :user_id
	validate :validate_dates, on: :create
	validate :check_date_availablity, on: :create	
	validate :calculate_room_price, on: :create
	def booking_confirmed
		if self.is_confirmed == true
			Notification.client_confirmed(self).deliver_now!
		end
	end

	def booking_confirmation
		Notification.client_confirmation(self).deliver_now!
		Notification.host_confirmation(self).deliver_now!
	end


	def validate_dates
		# if self.start_date < Date.today || self.end_date < self.start_date
		# 	self.errors.add(:date," you are trying is not in the currect")
		#  end	

		if (self.start_date < Date.today)
			self.errors.add(:base, "Date can not be less than today")
		end
		if (self.start_date > self.end_date)
			self.errors.add(:base, "End date can not be less than start date")
		end
	
	end

	def check_date_availablity
		current_booking = (self.start_date..self.end_date).to_a
		previous_bookings = Booking.where('room_id =?', self.room_id)
		previous_bookings.each do |booking|
			previous_booking_date = (booking.start_date..booking.end_date).to_a
			current_booking.each do |booking|
				if previous_booking_date.include?(booking)	
					self.errors.add(:base, "already booked")
					break
				end
			end
		end
	end

	def calculate_room_price
	total = 0
	count = 0
	current_booking = (self.start_date..self.end_date).to_a
	
		self.room.special_prices.each do |special_price|
			if special_price.room_id == self.room_id
				dates = ((special_price.start_date..special_price.end_date)).to_a
				#binding.pry
				dates.each do |date|
					if current_booking.include?date
						total += special_price.price
						#binding.pry
						count +=1 
						#binding.pry
					end
				end
			end
		end
		count = current_booking.length - count
		#binding.pry
		total = total + self.room.price * count
		#binding.pry
		self.price = total 
	 end
end
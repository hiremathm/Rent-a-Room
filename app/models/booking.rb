class Booking < ActiveRecord::Base

	after_update :booking_confirmed
	after_create :booking_confirmation
	before_validation :calculate_room_price
	belongs_to :user
	belongs_to :room

	validates_presence_of :start_date, :end_date, :price, :room_id, :user_id
	validate :validate_dates	

	
	def booking_confirmed
		if self.is_confirmed == true
			Notification.client_confirmed(self).deliver_now!
		end
	end

	def booking_confirmation
		Notification.client_confirmation(self).deliver_now!
		Notification.host_confirmation(self).deliver_now!
	end

	def calculate_room_price
	 	self.price = (self.start_date..self.end_date).count * self.room.price
	end

	def validate_dates
		if self.start_date < Date.today || self.end_date < self.start_date
			self.errors.add(:date," you are trying is not in the currect")
		 end	
	end
end

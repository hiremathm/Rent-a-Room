class SpecialPrice < ActiveRecord::Base
	validates :start_date, :end_date, :price, presence: true
	validates :price,  numericality: true

	belongs_to :room
	validate :check_date_price, on: :create
	validate :check_date, on: :create

	def check_date_price
		current_booking = (self.start_date..self.end_date).to_a
		previous_special_dates = SpecialPrice.where('room_id =?', self.room_id)
			
		previous_special_dates.each do |special_price|
			dates = (special_price.start_date..special_price.end_date)

			current_booking.each do |date|
				if dates.include?date
				self.errors.add(:base, "This date has special price");
				break
				end
			end
		end
	end

	def check_date
		if self.start_date < Date.today
			self.errors.add(:base,"Start date cannot be less than Today Date........ ")
		elsif(self.end_date < self.start_date)
			self.errors.add(:base,"End date cannot be less than Start Date........")
		end
	end
end
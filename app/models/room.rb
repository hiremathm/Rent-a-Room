class Room < ActiveRecord::Base
	after_create :change_role
	before_save :determine_lat_and_long
	after_update :authorize_confirmation

	mount_uploader :images, ImageUploader

	has_many :amenity_rooms
	has_many :amenities, through: :amenity_rooms
	has_many :bookings

	belongs_to :user
	belongs_to :city

	validates_presence_of :name, :description, :price, :rules, :address, :images, :city_id, :user_id
	validates_uniqueness_of :name
	validates_numericality_of :price, :city_id, :user_id
	validates_length_of :description, minimum: 150

	
	private

	def change_role
		if self.user.role.name == "guest"
			self.user.update_attributes(role_id: Role.second.id)
		end
	end

	def determine_lat_and_long
		response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}&key=AIzaSyA6RqNAKM2gUdLcMmV4F0Fn_jz_e93xRBk")

		#result = JSON.parse(response.body)
		
		self.latitude = response["results"][0]["geometry"]["location"]["lat"]
		self.longitude = response["results"][0]["geometry"]["location"]["lng"]
	end

	def authorize_confirmation
		if self.is_authorized == true
			Notification.authorize_confirmation(self).deliver_now!
		end
	end

end
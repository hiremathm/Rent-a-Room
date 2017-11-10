class Room < ActiveRecord::Base
	after_create :change_role
	before_save :determine_lat_and_long
	mount_uploader :images, ImageUploader

	has_many :amenity_rooms
	has_many :amenities, through: :amenity_rooms

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
		response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}")

		result = JSON.parse(response.body)
		
		self.latitude = result["results"][0]["geometry"]["location"]["lat"]
		self.longitude = result["results"][0]["geometry"]["location"]["lng"]
	end
end
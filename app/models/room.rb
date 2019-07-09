class Room < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: [:slugged, :finders]
	mount_uploader :images, ImageUploader	
	after_create :change_role
	before_save :determine_lat_and_long	
	has_many :amenity_rooms
	has_many :amenities, through: :amenity_rooms
	has_many :bookings
	has_many :special_prices, dependent: :destroy
	has_many :reviews, dependent: :destroy

	belongs_to :user
	belongs_to :city

	validates_presence_of :name, :description, :price, :rules, :address, :city_id, :user_id
	validates_uniqueness_of :name
	validates_numericality_of :price, :city_id, :user_id
	validates_length_of :description, minimum: 5

	scope :athorized_rooms, -> (bool = true) {where(is_authorized: bool)} 

	private

	def change_role
		if self.user.role.name == "guest"
			self.user.update_attributes(role_id: Role.second.id)
		end
	end

	def determine_lat_and_long
		# AIzaSyCGXQJSvHpGwHh-6BTpDY0WEkunObhKBQo
		response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.address}
			&key=AIzaSyAd6eOLMfqEt_PA_pGEOxHIGl5t-Yzsghw")
		result = JSON.parse(response.body)
		if result[0].present?
		self.latitude = result["results"][0]["geometry"]["location"]["lat"]
		self.longitude = result["results"][0]["geometry"]["location"]["lng"]
		else
			determine_lat_and_long
		end
		#Using geocoder Gem 
		# results = Geocoder.search('banglore')
		# self.latitude = "25.2426006" #results.first.coordinates[0]
		# self.longitude = "55.3064397" #results.first.coordinates[1]
	end
end
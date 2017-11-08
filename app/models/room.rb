class Room < ActiveRecord::Base

	after_create :change_role

	has_many :amenity_rooms
	has_many :amenities, through: :amenity_rooms
	belongs_to :user
	belongs_to :city

	validates_presence_of :name, :description, :price, :rules, :address, :images, :latitude, :longitude, :city_id, :user_id
	validates_uniqueness_of :name
	validates_numericality_of :price, :city_id, :user_id
	validates_length_of :description, minimum: 150

	def change_role
		if self.user.role.name == "guest"
			self.user.update_attributes(role_id: Role.second.id)
		end
	end
end
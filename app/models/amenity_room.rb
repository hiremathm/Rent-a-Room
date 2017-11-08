class AmenityRoom < ActiveRecord::Base

	belongs_to :user
	belongs_to :room
	
	validates_presence_of :room_id, :amenity_id
	validates_numericality_of :room_id, :amenity_id

end

class Review < ActiveRecord::Base
	belongs_to :room
	belongs_to :user
	validates :review, :food_rating, :cleanliness_rating, :safety_rating, :facility_rating, :locality_rating, presence: true
	validates_length_of :review, minimum: 15

end

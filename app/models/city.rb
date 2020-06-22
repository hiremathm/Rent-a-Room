class City < ActiveRecord::Base
	extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
	has_many :rooms

	validates_presence_of :name
	
end

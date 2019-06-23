class State < ActiveRecord::Base
	# extend FriendlyId
  	# friendly_id :name, use: [:slugged, :finders]
	has_many :cities
	validates_presence_of :name
end

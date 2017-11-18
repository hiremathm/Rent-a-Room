class City < ActiveRecord::Base

	has_many :rooms

	validates_presence_of :name
	
end

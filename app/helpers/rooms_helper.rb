module RoomsHelper
	def get_all_rooms
		Room.authorized_rooms
	end
end

class Api::V1::RoomsController < Api::V1::BaseController
	
	before_action :doorkeeper_authorize!
	# protect_from_forgery with: :null_session
	def index
		rooms = Room.all
		render json: rooms
	end

	def show
		room = Room.find(params['id']) rescue nil
		if room 
			render json: {status: "SUCCESS", message: "Loaded Room", data: room}, status: :ok
		else
			render json: {message: "Record Not found"}
		end
	end

	def create
		room = Room.new(room_params)
		if room.save
			render json: room, status: :ok, message: "Successfully created."
		else
			render json: {message: "Record Not created", status: :unprocessable_entity}
		end
	end

	def destroy
		room = Room.find(params['id'])
		if room.destroy
			render json: {status: :ok, message: "Record Successfully deleted"}
		else
			render json: {message: "Record Not created", status: :unprocessable_entity}
		end
	end

	def update
		room = Room.find(params['id'])
		if room.update(room_params)
			render json: {status: :ok, message: "Record Successfully updated"}
		else
			render json: {message: "Record Not found", status: :unprocessable_entity}
		end
	end

	def find_rooms_by_user_id
    	rooms = current_user.present? && current_user.rooms.count != 0 ? current_user.rooms : nil
		if !rooms.nil?
			render json: {rooms: rooms, message: "Your total rooms are #{rooms.count}", status: :ok}
		else
			render json: {message: "No Rooms found", status: :unprocessable_entity}
		end
	end

  	def find_unauthorized_rooms_by_user_id
    	rooms = current_user.rooms.where('is_authorized = ?', false)
  		rooms = rooms.present? && rooms.count != 0 ? rooms : nil
		if !rooms.nil?
			render json: {rooms: rooms, message: "Total unauthorized rooms are #{rooms.count}", status: :ok}
		else
			render json: {message: "No unauthorized Rooms found", status: :unprocessable_entity}
		end
  	end

  	def find_authorized_rooms_by_user_id
    	rooms = current_user.rooms.where('is_authorized = ?', true)
  		puts "count : #{rooms.count}"
  		rooms = rooms.present? && rooms.count != 0 ? rooms : nil
		if !rooms.nil?
			render json: {rooms: rooms, message: "Total authorized rooms are #{rooms.count}", status: :ok}
		else
			render json: {message: "No authorized Rooms found", status: :unprocessable_entity}
		end
  	end

  	def find_unauthorized_rooms
    	rooms = Room.where('is_authorized = ?', false)
  		rooms = rooms.present? && rooms.count != 0 ? rooms : nil
		if !rooms.nil?
			render json: {rooms: rooms, message: "Total unauthorized rooms are #{rooms.count}", status: :ok}
		else
			render json: {message: "No unauthorized Rooms found", status: :unprocessable_entity}
		end
  	end

  	def find_authorized_rooms
    	rooms = Room.where('is_authorized = ?', true)
  		rooms = rooms.present? && rooms.count != 0 ? rooms : nil
		if !rooms.nil?
			render json: {rooms: rooms, message: "Total authorized rooms are #{rooms.count}", status: :ok}
		else
			render json: {message: "No authorized Rooms found", status: :unprocessable_entity}
		end
  	end

	private 
	# Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :description, :price, :rules, 
        :address, :images, :latitude, :longitude, :city_id, :user_id, :is_authorized, :state_id, :house_type, :house_plan,amenity_ids:[])
    end
end
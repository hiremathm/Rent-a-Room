class Api::V1::RoomsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
	def index
		@rooms = Room.all
		render json: @rooms
	end

	def show
		room = Room.find(params['id']) rescue nil
		if room 
			render json: {status: "SUCCESS", message: "Loaded Articles", data: room}, status: :ok
		else
			render json: {message: "Record Not found"}
		end
	end

	def create
		@room = Room.create(room_params)
		if @room
			render json: @room, status: :ok, message: "Successfully created."
		else
			render json: {message: "Record Not created", status: :unprocessable_entity}
		end
	end

	def destroy
		@room = Room.find(params['id'])
		if @room.destroy
			render json: {status: :ok, message: "Record Successfully deleted"}
		else
			render json: {message: "Record Not created", status: :unprocessable_entity}
		end
	end

	def update
		@room = Room.find(params['id'])
		if @room.update(room_params)
			render json: {status: :ok, message: "Record Successfully updated"}
		else
			render json: {message: "Record Not found", status: :unprocessable_entity}
		end
	end

	private 
	# Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :description, :price, :rules, 
        :address, :images, :latitude, :longitude, :city_id, :user_id, :is_authorized, :state_id, :house_type, :house_plan,amenity_ids:[])
    end
end
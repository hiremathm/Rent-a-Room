class AmenityRoomsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  #load_and_authorize_resource

  before_action :set_amenity_room, only: [:show, :edit, :update, :destroy]

  # GET /amenity_rooms
  # GET /amenity_rooms.json
  def index
    @amenity_rooms = AmenityRoom.all
  end

  # GET /amenity_rooms/1
  # GET /amenity_rooms/1.json
  def show
  end

  # GET /amenity_rooms/new
  def new
    @amenity_room = AmenityRoom.new
  end

  # GET /amenity_rooms/1/edit
  def edit
  end

  # POST /amenity_rooms
  # POST /amenity_rooms.json
  def create
    @amenity_room = AmenityRoom.new(amenity_room_params)

    respond_to do |format|
      if @amenity_room.save
        format.html { redirect_to @amenity_room, notice: 'Amenity room was successfully created.' }
        format.json { render :show, status: :created, location: @amenity_room }
      else
        format.html { render :new }
        format.json { render json: @amenity_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amenity_rooms/1
  # PATCH/PUT /amenity_rooms/1.json
  def update
    respond_to do |format|
      if @amenity_room.update(amenity_room_params)
        format.html { redirect_to @amenity_room, notice: 'Amenity room was successfully updated.' }
        format.json { render :show, status: :ok, location: @amenity_room }
      else
        format.html { render :edit }
        format.json { render json: @amenity_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amenity_rooms/1
  # DELETE /amenity_rooms/1.json
  def destroy
    @amenity_room.destroy
    respond_to do |format|
      format.html { redirect_to amenity_rooms_url, notice: 'Amenity room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amenity_room
      @amenity_room = AmenityRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def amenity_room_params
      params.require(:amenity_room).permit(:room_id)
    end
end

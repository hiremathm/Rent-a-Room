class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @roomarray = Room.all
    @roomarray = Room.paginate(:page => params[:page], :per_page => 5)
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @booking = Booking.new
    @special_price = SpecialPrice.new
    @review = Review.new
    end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id
    respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_path, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
     if @room.destroy
        respond_to do |format|
            format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
            format.json { head :no_content }
    else 
        render action: "show"    
    end
  end

  def authorize
    @room = Room.where('is_authorized = ?', false)
  end

  def my_rooms

    @r = current_user.rooms
  
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :description, :price, :rules, 
        :address, :images, :latitude, :longitude, :city_id, :user_id, :is_authorized, amenity_ids:[])
    end
end
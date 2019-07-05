class RoomsController < ApplicationController
  include RoomsHelper
  before_action :authenticate_user!, except: [:index, :show,:find_by_cities,:by_price_asc,:by_price_desc, :get_all_cities]
  load_and_authorize_resource
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  
   def by_price_asc
    @rooms = Room.order(:price)
    render json: @rooms
   end

   def by_price_desc
    @rooms = Room.order(price: :desc)
    render json: @rooms
   end
  def index
    if params.present?
      if params['state_id'].present?
        @rooms = Room.where(state_id: params['state_id'])
      end
      if params['city_id'].present? and params['city_id'] != 'undefined'
        @rooms = @rooms.where(city_id: params['city_id'])
      end
      if params['type'].present?
        @rooms = @rooms.where(house_type: params['type'])
      end
      if params['plan'].present?
        @rooms = @rooms.where(house_plan: params['plan'])
      end
    else 
      @rooms = Room.all
    end
    respond_to do |format|
      format.html
      format.js { render :file => "rooms/index.js.erb", :layout => false}
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.friendly.find(params[:id])
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

  def get_all_cities
    @cities = City.where(state_code: params['state'])
    render json: @cities
  end

  def find_by_cities
      if params[:city_ids] != ""
        @rooms = Room.where(city_id: params[:city_ids].split(","))
      else 
         @rooms = Room.all
      end 
        render json: @rooms
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
        if @room.is_authorized == true 
          Mailer.delay(:queue => "Authorize room",run_at: 5.minutes.from_now).authorize_confirmation(@room)
        end
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
        end
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
        :address, :images, :latitude, :longitude, :city_id, :user_id, :is_authorized, :state_id, :house_type, :house_plan,amenity_ids:[])
    end
end
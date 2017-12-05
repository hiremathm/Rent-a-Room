class BookingsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  
  def create
    @book = Booking.new(booking_params)
    #binding.pry
    if current_user.role.name != "admin"
      @book.user_id = current_user.id
    end
    if @book.save
      render action: "show", notice: "Your room has been booked"
     else
       render action: "new"
    end
  end
  
   def edit
     @booking = Booking.find(params[:id])
   end  
  def update
  	@booking = Booking.find(params[:id])
    #binding.pry
  	if @booking.update_attributes(booking_params)  
  	#binding.pry
      redirect_to rooms_path, notice: "Succefully updated booking"
    else
      redirect_to rooms_path, notice: "Unable to update the booking"
    end
  end

  def destroy
    @book = Booking.find(params[:id])
    @book.destroy 
        redirect_to bookings_path, notice: "Your Booked Room has been Deleted"
  end

  def confirmation
  	#@b = Booking.where('is_confirmed = ?', false) 
    @b = Booking.joins(:room).where('rooms.user_id = ? AND is_confirmed =?', current_user.id, false)
  end

  def my_bookings
    @bookings = current_user.bookings
  end

  private
  def booking_params
    params[:booking].permit(:start_date, :end_date, :price, :room_id, :user_id, :is_confirmed)
  end

end
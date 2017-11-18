class BookingsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
  #load_and_authorize_resource
  def create
    @book = Booking.new(booking_params)
    #binding.pry
    @book.user_id = current_user.id
    if @book.save
    
      redirect_to rooms_path, notice: "Your room has been booked"
     else
       render action: "new"#, notice: "#{@booking.errors[:date]}"
    end
  end
  
  def update
  	@booking = Booking.find(params[:id])
  	if @booking.update_attributes(booking_params)  
  		redirect_to bookings_confirmation_path, notice: "Succefully updated booking"
    else
      redirect_to bookings_confirmation_path, notice: "Unable to update the booking"
    end
  end

  def confirmation
  	@booking = Booking.where('is_confirmed = ?', false) 
  end

  private
  def booking_params
    params[:booking].permit(:start_date, :end_date, :price, :room_id, :user_id, :is_confirmed)
  end

end
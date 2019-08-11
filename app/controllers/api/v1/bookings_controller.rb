class BookingsController < ApplicationController

  before_action :doorkeeper_authorize!
  
  def index
    bookings = Booking.all
    if bookings.present? && bookings.count != 0
      render json: {message: "All Bookings", count: bookings.count, status: :Ok}
    else
      render json: {message: "No Bookings found", status: :unprocessable_entity}
    end
  end

  def create
    book = Booking.new(booking_params)
    if current_user.role.name != "admin"
      book.user_id = current_user.id
    end
    if book.save
      render json: { message: 'City was successfully created.', status: :Ok }
    else
      render json: { errors: booking.errors, status: :unprocessable_entity }
    end
  end

  def edit
    booking = Booking.find(params[:id])
    if booking.present?
      render json: {booking: booking, status: :Ok}
    else
      render json: {error: "Booking Not found", status: :unprocessable_entity}
    end
  end

  def update
  	booking = Booking.find(params[:id])
  	if booking.update(booking_params)
      render json: { message: 'City was successfully updated.', status: :Ok }
    else
      render json: { errors: booking.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    city.destroy
    render json: { notice: 'City was successfully destroyed.', status: :Ok }
  end

  def find_bookings_by_user_id
    bookings = current_user.bookings
    if bookings.present? && bookings.count != 0
      render json: {bookings: bookings, message: "Your all bookings count is #{bookings.count}", status: :Ok}
    else
      render json: {message: "You dont not have any bookings", status: :unprocessable_entity}
    end
  end

  def get_all_confirmed_bookings_by_user_id
    bookings = current_user.bookings.wehre(is_confirmed: true)
    
    if bookings.present? && bookings.count != 0
      render json: {bookings: bookings, message: "Your all confirmed bookings count is #{bookings.count}", status: :Ok}
    else
      render json: {message: "You dont not have confirmed bookings", status: :unprocessable_entity}
    end
  end

  def get_all_notconfirmed_bookings_by_user_id
    bookings = current_user.bookings.wehre(is_confirmed: false)
    
    if bookings.present? && bookings.count != 0
      render json: {bookings: bookings, message: "Your all not confirmed bookings count is #{bookings.count}", status: :Ok}
    else
      render json: {message: "You dont not have not confirmed bookings", status: :unprocessable_entity}
    end
  end

  private
  def booking_params
    params[:booking].permit(:start_date, :end_date, :price, :room_id, :user_id, :is_confirmed)
  end
end
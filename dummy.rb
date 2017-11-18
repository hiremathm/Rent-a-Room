<h2> You can book room here</h2>
<%= form_for @book do |f| %>
  <div>
    <%= f.label :Start_date %>
    <%= f.date_select :start_date %>
  </div>
  <div>
    <%= f.label :End_date %>
    <%= f.date_select :end_date %>
  </div>
   
    <%= f.hidden_field :room_id, value: @room.id %>
   
    <%= f.hidden_field :price, value: @room.price %>
  
    <%= f.label :is_confirmed %>
      
    <%= f.check_box :is_confirmed %>
    
    
    <%= f.submit "BOOK ROOM" %>
    
<% end %>


  class BookingController < ApplicationController
  
  def index
  end
  def create
    @book = Booking.new(booking_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to room_path(@book.room), notice: "your has been booked"
    end
  end

  private
  def booking_params
    params[:booking].permit(:start_date, :end_date, :price, :room_id, :user_id, :is_confirmed)
  end

end


class BookingsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  
  def create
    @book = Booking.new(booking_params)
    if current_user.role.name != "admin"
      @book.user_id = current_user.id
    end
    if @book.save
      pdf = Prawn::Document.new
      pdf.move_cursor_to 700
      pdf.text @book.room.address, :size => 10, :color => "0000FE"
      pdf.bounding_box([380,700], :width => 150, :height => 100) do 
        pdf.text "RENT SLIP", :size => 12, :color => "0000FE"
      end
      image = @book.room.images

      pdf.image "app/assets/images/myhomemainpage.jpg", :at => [250,680]
      
      pdf.move_cursor_to 625
      time = Time.now
      pdf.bounding_box([0,650], :width => 200, :height => 200) do 
        pdf.table([
            ["Date", time.day.to_s + "/" + time.month.to_s + "/" + time.year.to_s]
          ])
      end

      pdf.bounding_box([0, 600], :width => 200, :height => 200) do 
        pdf.text "To", :size => 14
        pdf.text @book.user.first_name.capitalize + " " +  @book.user.last_name.capitalize
      end

      pdf.bounding_box([0, 500], :width => 550, :height => 300) do
        pdf.table([
            ["Name    ","Start Date  ", "End Date", "Bill per Day","Total"],
            [@book.room.name, @book.start_date, @book.end_date, @book.room.price, @book.price]
          ])
      end
      
      filename = "invoice.pdf"
      pdf.render_file filename

      session[:booking] = @book 
      Mailer.host_confirmation(@book).deliver_later
      Mailer.client_confirmation(@book, filename).deliver_later
      redirect_to choose_payment_path, notice: "Your room has been booked , Please do the payments"
    else
       render action: "new"
    end
  end

  def send_data
    @booking = session[:booking]
  end

  def paytm_payment
    @booking = session[:booking]
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
  	@booking = Booking.find(params[:id])
  	if @booking.update_attributes(booking_params)  
      if @booking.is_confirmed == true
        Mailer.delay(:queue => "Booking confirmed",run_at: 5.minutes.from_now).client_confirmed(@booking)
      end
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
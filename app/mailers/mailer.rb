class Mailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.authorize_confirmation.subject
  #
  def authorize_confirmation(room)
    @room = room
    mail to: "#{@room.user.email}", subject: "Room authorized"
  end

  def host_confirmation(host)
  	@host = host
  	mail to: "#{@host.room.user.email}", subject: "Room confirmation"
  end

  def client_confirmation(booking, filename)
    attachments["Rent_Invoice.pdf"] = open(filename).read
  	@booking = booking
  	mail to: "#{@booking.user.email}", subject: "Room booking confirmation mail."
  end

  def client_confirmed(client)
  	@client = client
  	mail to: "#{@client.user.email}", subject: "Room confirmed"
  end

  def send_enquiry(enquiry)
    @enquiry = enquiry
    # default from: "#{@enquiry.email}"
    mail to: "#{User.find_by(role_id: 1).email}", subject: "#{@enquiry.subject}"
  end
end

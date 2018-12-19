class Notification < ApplicationMailer

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

  def client_confirmation(client)
  	@client = client
  	mail to: "#{@client.user.email}", subject: "Room booked"
  end

  def client_confirmed(client)
  	@client = client
  	mail to: "#{@client.user.email}", subject: "Room confirmed"
  end

  def rent_bill(book, filename)
    attachments["Rent_Invoice.pdf"] = open(filename).read
    @book = book
    mail to: "#{@book.user.email}", subject: "Invoice Bill For Room Rent"
  end

  def send_enquiry(enquiry)
    @enquiry = enquiry
    # default from: "#{@enquiry.email}"
    mail to: "#{User.find_by(role_id: 1).email}", subject: "#{@enquiry.subject}"
  end
end

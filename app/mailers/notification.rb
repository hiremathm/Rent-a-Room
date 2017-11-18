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
end

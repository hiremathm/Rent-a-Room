class Enquiry < ActiveRecord::Base

	validates_presence_of :subject, :email, :description

	# after_create :send_enquiry_to_admin

	def send_enquiry_to_admin
		Notification.send_enquiry(self).deliver_now!
	end

end

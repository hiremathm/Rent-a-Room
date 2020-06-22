class Users::RegistrationsController < Devise::RegistrationsController
	def create
		build_resource(sign_up_params)
		if true
			super
		else
			render 'new'
		end
	end
end
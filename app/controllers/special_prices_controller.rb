class SpecialPricesController < ApplicationController
	before_action :authenticate_user!
  	load_and_authorize_resource#	:special_price, :through => :room

  	# def new
  	# 	@special_price = SpecialPrice.new
  	# end
  	def create
		@specialprice = SpecialPrice.new(special_price_params)
		#binding.pry
		if @specialprice.save 
			redirect_to room_path(@specialprice.room_id), notice: "You have successfully created specialprice"
		else
			render action: "new"
		end
	end

	private
	def special_price_params
		params[:special_price].permit(:start_date, :end_date, :price, :room_id)
	end
end

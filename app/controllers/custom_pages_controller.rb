class CustomPagesController < ApplicationController

	def home	
	end

	def about
	end

	def contact
		
	end
	def amazon
	  @epoch_time =( Time.now.to_f*1000).ceil
	  @merchant_id = "AZ4WQCLDT2DF0"

	  access_token = "Atza|IwEBIDzD2Q7NIvbYnrZT5BYFaGLbhzTeCmnb9KJb1m-4pxISPTDKTz7eobT4HjitJMcGRZTQ4BBUupwSnf8gbaCrCWSSOkFWl6n62Qu3bk1QKfsyJIPa7Ddel75f2eThxWbxXmpzRIMFHklsAlmvbmYMhFs0fsw2c8PfSDxVOgJTPWfD4XTOub3OhL5m1522htoMRf_dAZYpEbCnTgDL2D8aax1TXLIDuWwlnV8BKkZRhoOQF4qV9PoBtNwm5LvOfzZdyaCBcoR3_wWDWcEI-yI2R8r7xnjLhtVBKMuN3EbY1Z8iWNmJe_z-h2bzHj6CuBExoZcsxVvswRTjLiiKzKWSNYqJ7Pth4ugZSN7s4w4fGCIYiCXzpgEtPXXucMYpst0XSe-xR82n7YH4gLFLrBAWog6rm8PoYnX75GLzhuKHLlLjRfMU4oW-i8aaJJC4pZNfzvuOQIPV2cEZfAHe2NiUf_7POUB5s4mNxy1nsw1DUJFDBGm4FOpPk5xiHseTDWHQPvP3_IV0NRk5P1a2jbEmM_w7BbhE_E4XoE_mIWKM6-0qd0WbgzdNqAGWPWOopsJO0M0"
      @url = "https://amazonpay.amazon.in/customer/CONSENT_TOKEN/#{access_token}/balance/v1"

      puts "@url #{@url}"
	end
end

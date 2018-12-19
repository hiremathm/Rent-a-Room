class PaymentsController < ApplicationController
require 'openssl'
require 'base64'
skip_before_action :verify_authenticity_token
# load_and_authorize_resource

  def index
  end
  
  def cf_Request
    @order_id = params[:id]#SecureRandom.base64(6).to_s
  	mode = "TEST"
    @user_id = params[:user_id] 
    @postData = {
      "appId" => "15976ce3ac81a31af2c8b6b951",
      "orderId" => params[:id],
      "orderAmount" => params[:price],
      "orderCurrency" => "INR",
      "orderNote" => "Test Data",
      "customerName" => User.find(params[:user_id]).username,
      "customerPhone" => User.find(params[:user_id]).mobile,
      "customerEmail" => User.find(params[:user_id]).email,
      "returnUrl" => "http://localhost:3000/response/#{@user_id}/#{@order_id}",
      "notifyUrl" => "http://localhost:3000/cf_Response"
    }
  	@signatureData =""
    #@app_id = "15976ce3ac81a31af2c8b6b951"
  	@secretKey = "c5762b4b4579491e041f56e1fddfc3e57964e8c6"
  	@postData.sort.map do |key,value|
  		@signatureData += key + value
  	end
 	if mode == "PROD"
 		@url = "https://www.cashfree.com/checkout/post/submit"
 	else
 		@url = "https://test.cashfree.com/billpay/checkout/post/submit"
 	end
 	@signature = Base64.encode64(OpenSSL::HMAC.digest('sha256', @secretKey, @signatureData)).strip()
  end


  def cf_Response
    # binding.pry
    @postData = {
    "orderId" => params[:'orderId'], 
    "orderAmount" => params[:'orderAmount'], 
    "referenceId" => params[:'referenceId'], 
    "txStatus" => params[:'txStatus'], 
    "paymentMode" => params[:'paymentMode'], 
    "txMsg" => params[:'txMsg'], 
    "txTime" => params[:'txTime']
   	}
  	@secretKey = "c5762b4b4579491e041f56e1fddfc3e57964e8c6"
    @signature = params[:'signature']
   	@signatureData = ""
   	@postData.each do |key,value|
  		@signatureData += value
  	end
 	@computedsignature = Base64.encode64(OpenSSL::HMAC.digest('sha256', @secretKey, @signatureData)).strip()
  end	
end

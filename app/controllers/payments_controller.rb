require Rails.root.join("lib/paytm_helper.rb")
class PaymentsController < ApplicationController
  require 'openssl'
  require 'base64'
  skip_before_action :verify_authenticity_token
  # load_and_authorize_resource
  include PaytmHelper::EncryptionNewPG
  # protect_from_forgery except: [:paytm_response]

  def index
  end
  
  def choose_payment  
  end

  def redirect_payment_page
    if params["payment_type"] == "Cashfree"
    redirect_to cashfree_payment_path, notice: "You have selected #{params["payment_type"]}, you are redirecting to the #{params["payment_type"]} payment page."
    else
      redirect_to paytm_payment_path
    end
  end

  def cf_Request
    @order_id = SecureRandom.base64(6).to_s
  	mode = "TEST"
    @user_id = params[:user_id] 
    @postData = {
      "appId" => "15976ce3ac81a31af2c8b6b951",
      "orderId" => @order_id,
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

  def paytm_request
    payment_environment = 'staging' #(params[:payment_environment] == 'production' ? :production : :staging)
    user = User.find(params["user_id"])
    order_id = params["id"] #SecureRandom.base64(6).to_s
    cust_id = user.id
    txn_amount = params["price"]
    mobile_no = user.mobile
    email = user.email

    #param list
    @param_list = Hash.new
    @param_list["MID"] = ""                        
    @param_list["ORDER_ID"] = order_id
    @param_list["CUST_ID"] = cust_id
    @param_list["INDUSTRY_TYPE_ID"] = "Retail" 
    @param_list["CHANNEL_ID"] =  "WEB"          
    @param_list["TXN_AMOUNT"] = 1.00  #txn_amount
    @param_list["MOBILE_NO"] = mobile_no
    @param_list["EMAIL"] = email
    @param_list["WEBSITE"] =  "WEBSTAGING" 
    # @param_list["MERCHANT_KEY"] = "K0UoTK4Fh#wd%fqX"
    @param_list["CALLBACK_URL"] = "http://localhost:3001/paytm_response"  #"https://pg-staging.paytm.in/MerchantSite/bankResponse" 
    @checksum_hash = new_pg_checksum(@param_list, "").gsub("\n",'')

    puts "Parameter to paytm : #{@param_list}"
    puts "Checksum to paytm : #{@checksum_hash}" 
    @payment_url = "https://securegw-stage.paytm.in/theia/processTransaction"
  end

  def paytm_response
    @response = params
  end
end

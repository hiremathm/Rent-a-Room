require Rails.root.join("lib/paytm_helper.rb")
class PaymentsController < ApplicationController
  require 'openssl'
  require 'base64'
  skip_before_action :verify_authenticity_token
  # load_and_authorize_resource
  include PaytmHelper::EncryptionNewPG
  include PaytmHelper::ChecksumTool


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
    config_setup = Config.where(config_id: "5003", title: "cashfree").last
    config_array = config_setup["info"].map { |k| eval(k)}
    env = Rails.env
    cashfree_setup = config_array.map {|p| p if p[:environment] == env}.compact.last 
    @order_id = "RENT"+ Random.rand(1000).to_s + "ROOM"
    @user_id = params[:user_id] 
    @postData = {
      "appId" => cashfree_setup[:appId],
      "orderId" => @order_id,
      "orderAmount" => params[:price],
      "orderCurrency" => "INR",
      "orderNote" => "Test Data",
      "customerName" => User.find(params[:user_id]).username,
      "customerPhone" => User.find(params[:user_id]).mobile,
      "customerEmail" => User.find(params[:user_id]).email,
      "returnUrl" => cashfree_setup[:returnUrl] + "/#{@user_id}/#{@order_id}",
      "notifyUrl" => cashfree_setup[:notifyUrl] 
    }
    @signatureData =""
    @secretKey = cashfree_setup[:secreatKey]
    @postData.sort.map do |key,value|
      @signatureData += key + value
    end
    @url = cashfree_setup[:payment_url]
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
    
    config_setup = Config.where(config_id: "5001", title: "paytm").last
    puts "config setup : " + "#{config_setup}"
    config_array = config_setup["info"].map { |k| eval(k)}
    env = Rails.env
    paytm_setup = config_array.map {|p| p if p[:environment] == env}.compact.last 
     puts "Paytm Setup : #{paytm_setup}"
    #param list
    @param_list = Hash.new
    @param_list["MID"] = paytm_setup[:mid]                       
    @param_list["ORDER_ID"] =  order_id.to_s + "RENT"+ Random.rand(1000).to_s + "ROOM" 
    @param_list["CUST_ID"] = cust_id
    @param_list["INDUSTRY_TYPE_ID"] = paytm_setup[:industry_type_id] 
    @param_list["CHANNEL_ID"] =  paytm_setup[:channel_id]          
    @param_list["TXN_AMOUNT"] = txn_amount
    @param_list["MOBILE_NO"] = mobile_no
    @param_list["EMAIL"] = email
    @param_list["WEBSITE"] =  paytm_setup[:website] 
    @param_list["CALLBACK_URL"] = paytm_setup[:callback_url] 
    @checksum_hash = new_pg_checksum(@param_list,paytm_setup[:merchant_key]).gsub("\n",'')
    puts "Parameter to paytm : #{@param_list}"
    puts "Checksum to paytm : #{@param_list['CHECKSUMHASH']}" 
    @payment_url = paytm_setup[:payment_url]
  end

  def paytm_response
    @response = params
    response = {}
    keys = params.keys
    keys.each do |p|
      response[p] = params[p]
    end
    status = get_checksum_verified_array(response,"K0UoTK4Fh#wd%fqX")
    if status = 'N'
      @response = params
    else
      @response = params
    end
  end
end

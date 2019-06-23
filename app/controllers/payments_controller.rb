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
    # ott_res = JSON.parse(params['ott'])
    # ott_res = ott_res['data']
    # @param_list = Hash.new
    # @param_list['MID'] = ott_res["MID"]
    # @param_list['ORDER_ID'] = ott_res["ORDER_ID"]
    # @param_list['CUST_ID'] = ott_res["CUST_ID"]
    # @param_list['INDUSTRY_TYPE_ID'] = ott_res["INDUSTRY_TYPE_ID"]
    # @param_list['CHANNEL_ID'] = ott_res["CHANNEL_ID"]
    # @param_list['TXN_AMOUNT'] = ott_res["TXN_AMOUNT"]
    # @param_list['WEBSITE'] = ott_res["WEBSITE"]
    # @param_list['MERC_UNQ_REF'] = ott_res["MERC_UNQ_REF"]
    # @param_list['CALLBACK_URL'] = ott_res["CALLBACK_URL"]
    # @param_list['CHECKSUMHASH'] = ott_res["CHECKSUMHASH"]

    #4592040001316605
    #04/22
    #498
    
    #param list
    @param_list = Hash.new
    @param_list["MID"] = "rxazcv89315285244163"                       
    @param_list["ORDER_ID"] =  order_id.to_s + Random.rand(1000).to_s 
    @param_list["CUST_ID"] = cust_id
    @param_list["INDUSTRY_TYPE_ID"] = "Retail" 
    @param_list["CHANNEL_ID"] =  "WEB"          
    @param_list["TXN_AMOUNT"] = txn_amount
    @param_list["MOBILE_NO"] = mobile_no
    @param_list["EMAIL"] = email
    @param_list["WEBSITE"] =  "WEBSTAGING" 
    @param_list["CALLBACK_URL"] = "http://localhost:3001/paytm_response"
    @checksum_hash = new_pg_checksum(@param_list,"gKpu7IKaLSbkchFS").gsub("\n",'')
    puts "Parameter to paytm : #{@param_list}"
    puts "Checksum to paytm : #{@param_list['CHECKSUMHASH']}" 
    @payment_url = "https://securegw-stage.paytm.in/theia/processTransaction"
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

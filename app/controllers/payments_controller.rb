require Rails.root.join("lib/paytm_helper.rb")
class PaymentsController < ApplicationController
  require 'openssl'
  require 'base64'
  skip_before_action :verify_authenticity_token
  # load_and_authorize_resource
  include PaytmHelper::EncryptionNewPG
  include PaytmHelper::ChecksumTool

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
    puts "Checksum to paytm : #{@checksum_hash}" 
    @payment_url = "https://securegw-stage.paytm.in/theia/processTransaction"
  end

  def paytm_response
    @response = params
    response = {}
    keys = params.keys
    keys.each do |p|
      response[p] = params[p]
    end

    paytm_setting = {"name"=>"paytm", "MID"=>"rxazcv89315285244163", "INDUSTRY_TYPE_ID"=>"Retail", "CHANNEL_ID"=>"WEB", "WEBSITE"=>"WEBSTAGING", "CALLBACK_URL"=>"http://localhost:3001/paytm_response", "merchant_key"=>"gKpu7IKaLSbkchFS", "payment_url"=>"https://securegw-stage.paytm.in/theia/processTransaction", "status_check_url"=>"https://securegw-stage.paytm.in/order/status"}
    status = get_checksum_verified_array(response,"gKpu7IKaLSbkchFS")
    if status = 'N'
      @response = params
    else
      @response = params
    end
  end
end

require 'amazon_pay'

client_id = 'amzn1.application-oa2-client.aeb5fea5f6424ab996e16a868c6c3623'

login = AmazonPay::Login.new(
  client_id,
  region: :na,  
  sandbox: true 
)

puts "Login : #{login.inspect}"
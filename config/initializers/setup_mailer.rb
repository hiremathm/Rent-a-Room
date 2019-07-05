  config_setup = Config.where(config_id: "5001", title: "paytm").last
  config_array = config_setup.info.map { |k| eval(k)}
  mailer_setup = config_array.map {|p| p if p[:environment] == "development"}.compact.last 
  
ActionMailer::Base.smtp_settings = {
  :address => mailer_setup["address"],
  :port => mailer_setup["port"],
  :domain => mailer_setup["domain"],
  :user_name =>  mailer_setup["user_name"],
  :password =>  mailer_setup["password"],
  :authentication => mailer_setup["authentication"],
  :enable_starttls_auto => true
}
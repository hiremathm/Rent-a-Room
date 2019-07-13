status = ActiveRecord::Base.connection.table_exists? 'config'
if status
  # puts "Config Table existed"
  config_setup = Config.where(config_id: "5002", title: "mailer").last
  if config_setup.length != 0 && config_setup.length > 0 
    # puts "Configuration existed"
    puts "config setup : " + "#{config_setup}"
    config_array = config_setup["info"].map { |k| eval(k)}
    env = Rails.env
    mailer_setup = config_array.map {|p| p if p[:environment] == env}.compact.last 
      
    ActionMailer::Base.smtp_settings = {
      :address => mailer_setup["address"],
      :port => mailer_setup["port"],
      :domain => mailer_setup["domain"],
      :user_name =>  mailer_setup["user_name"],
      :password =>  mailer_setup["password"],
      :authentication => mailer_setup["authentication"],
      :enable_starttls_auto => true
    }
  end
end
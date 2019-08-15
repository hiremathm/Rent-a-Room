ActionMailer::Base.smtp_settings = {
:address => Rails.application.secrets[:address],
:port => Rails.application.secrets[:port],
:domain => Rails.application.secrets[:domain],
:user_name =>  Rails.application.secrets[:mail_id],
:password =>  Rails.application.secrets[:password],
:authentication => Rails.application.secrets[:authentication],
:enable_starttls_auto => Rails.application.secrets[:enable_starttls_auto]
}

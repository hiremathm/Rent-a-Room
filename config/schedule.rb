set :environment,"development"
set :output, "log/cron_log.log"
# env :PATH,ENV['PATH']
every 2.minutes do
  rake "change_room_price:change_price"
end

#rake change_room_price:change_price RAILS_ENV=development --trace
set :environment,"development"
set :output, "log/cron_log.log"
every 2.minutes do
  rake "change_room_price:change_price"
end
#RAILS_ENV=development bundle exec rake change_room_price:change_price
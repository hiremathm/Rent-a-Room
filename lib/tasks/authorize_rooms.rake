namespace :authorize do 
	task :authorize_all_rooms => :environment do
		Room.all.each do |r|
			r.update_attributes(is_authorized: true)
		end
	end
end
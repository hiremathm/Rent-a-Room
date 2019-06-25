task :add_aminities => :environment do 

	aminities = ["Wardrobe","Fan","Light","AC","Bed","Chimney","Curtains","DiningTable","ExhaustFan","Geyser","ModularKitchen","Microwave","Fridge","Sofa","Stove","TV","WashingMachine","WaterPurifier","StudyTable"]
	aminities.each do |aminity|
		Amenity.create(name: aminity, description: aminity, slug: aminity)
 	end
end	
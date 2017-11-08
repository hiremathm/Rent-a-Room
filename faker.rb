30.times do
c = City.new
c.name = Faker::Address.city
c.save
end

10.times do
c = Amenity.new
c.name = Faker::Book.title
c.description = Faker::Coffee.notes
c.save
end
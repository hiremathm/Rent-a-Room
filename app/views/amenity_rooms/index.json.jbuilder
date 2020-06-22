json.array!(@amenity_rooms) do |amenity_room|
  json.extract! amenity_room, :id, :room_id
  json.url amenity_room_url(amenity_room, format: :json)
end

json.array!(@reviews) do |review|
  json.extract! review, :id, :review, :food_rating, :cleanliness_rating, :safety_rating, :facility_rating, :locality_rating, :room_id, :user_id
  json.url review_url(review, format: :json)
end

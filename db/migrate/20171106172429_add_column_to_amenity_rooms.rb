class AddColumnToAmenityRooms < ActiveRecord::Migration
  def change
    add_column :amenity_rooms, :amenity_id, :integer
  end
end

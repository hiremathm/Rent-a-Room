class AddColumnToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :state_id, :integer
    add_column :rooms, :house_type, :string
    add_column :rooms, :house_plan, :string
  end
end

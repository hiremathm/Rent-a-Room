class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :price
      t.integer :user_id
      t.integer :room_id
      t.boolean :is_confirmed, default: false
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end

class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :start_date
      t.string :end_date
      t.integer :price
      t.integer :user_id
      t.integer :room_id
      t.boolean :is_confirmed, default: false

      t.timestamps null: false
    end
  end
end

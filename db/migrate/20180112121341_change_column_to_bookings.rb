class ChangeColumnToBookings < ActiveRecord::Migration
  def change
  	change_column :bookings, :start_date, :string
  	change_column :bookings, :end_date, :string
  end
end

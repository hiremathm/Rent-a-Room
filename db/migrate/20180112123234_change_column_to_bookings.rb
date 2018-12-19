class ChangeColumnToBookings < ActiveRecord::Migration
  	def change
  		change_table :bookings do |t|
  			# t.change :column_name, :column_type, {options}
			t.column :start_date, :date
  			t.column :end_date, :date
		end
	end
end

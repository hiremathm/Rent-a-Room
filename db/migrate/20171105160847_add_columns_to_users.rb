class AddColumnsToUsers < ActiveRecord::Migration
  def change
  	#first_name, last_name, username, email, mobile number, password, role_id

  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :username, :string
  	add_column :users, :mobile, :string
  	add_column :users, :role_id, :string
  
 	end
end

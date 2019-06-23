class AddColumnToCities < ActiveRecord::Migration
  def change
  	add_column :cities, :state_code, :string
  	add_column :cities, :city_code, :string
  end
end

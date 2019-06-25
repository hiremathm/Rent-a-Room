class AddColumnToSpecialPrices < ActiveRecord::Migration
  def change
    add_column :special_prices, :discount, :integer
  end
end

class AddSlugToAminities < ActiveRecord::Migration
  def change
  add_column :amenities,:slug,:string
  end

end

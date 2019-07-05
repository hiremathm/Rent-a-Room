class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.integer :config_id
      t.string :title
      t.text :info, array: true, default: []

      t.timestamps null: false
    end
  end
end

class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.string :subject
      t.string :email
      t.string :description

      t.timestamps null: false
    end
  end
end

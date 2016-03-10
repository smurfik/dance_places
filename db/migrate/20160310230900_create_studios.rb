class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :address
      t.string :url
      t.string :image
      t.string :facebook_id

      t.timestamps null: false
    end
  end
end

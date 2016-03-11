class AddAddressPartsToStudios < ActiveRecord::Migration
  def change
    add_column :studios, :city, :string
    add_column :studios, :zip_code, :string
    add_column :studios, :state, :string
    add_column :studios, :lat, :integer
    add_column :studios, :lng, :integer
  end
end

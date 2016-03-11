class RenameAddressToStreet < ActiveRecord::Migration
  def change
    rename_column :studios, :address, :street
  end
end

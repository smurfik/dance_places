class AddFacebookLinkToStudios < ActiveRecord::Migration
  def change
    add_column :studios, :facebook_link, :string
  end
end

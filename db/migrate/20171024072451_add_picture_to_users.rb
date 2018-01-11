class AddPictureToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :picture, :string
    add_column :users, :string, :string
  end
end

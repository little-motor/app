class AddReadToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :read, :boolean, default: false
  end
end

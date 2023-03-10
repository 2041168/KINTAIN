class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :roll, :integer, null: false,default: 1
    add_column :users, :kinmu, :integer, null: false,default: 1
  end
end
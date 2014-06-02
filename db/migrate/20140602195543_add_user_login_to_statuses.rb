class AddUserLoginToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :user_name, :string
    add_column :statuses, :password, :string
    
  end
end

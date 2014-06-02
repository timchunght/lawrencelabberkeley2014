class RemoveColumnFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :user_id
  end
end

class AddIsCheckedEmailToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_checked_email, :boolean, default: false
  end
end

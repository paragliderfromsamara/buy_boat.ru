class AddIsDraftToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :is_draft, :boolean, default: false
    add_column :products, :description, :string, default: ""
  end
end

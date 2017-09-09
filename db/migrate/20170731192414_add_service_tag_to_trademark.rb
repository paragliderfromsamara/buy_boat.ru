class AddServiceTagToTrademark < ActiveRecord::Migration[5.0]
  def change
    add_column :trademarks, :site_tag, :string, default: ""
  end
end

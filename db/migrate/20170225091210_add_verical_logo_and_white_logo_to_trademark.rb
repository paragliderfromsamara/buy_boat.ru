class AddVericalLogoAndWhiteLogoToTrademark < ActiveRecord::Migration[5.0]
  def change
    add_column :trademarks, :vertical_logo, :string
    add_column :trademarks, :white_logo, :string
  end
end

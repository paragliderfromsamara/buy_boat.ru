class CreateSelectedOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :selected_options do |t|
      t.integer :boat_for_sale_id
      t.integer :boat_option_type_id
      t.integer :arr_id
      t.string :rec_type
      t.string :rec_level
      t.string :param_name
      t.integer :amount, default: 0
    end
  end
end

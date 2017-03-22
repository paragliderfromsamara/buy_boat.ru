class CreateBoatOptionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_option_types do |t|
      t.string :rec_type
      t.string :name
      t.string :description
      t.integer :amount
      t.string :param_code
    end
  end
end

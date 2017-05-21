class CreatePropertyTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :property_types do |t|
      t.string :ru_name
      t.string :en_name
      t.string :ru_measure
      t.string :en_measure

      t.timestamps
    end
  end
end

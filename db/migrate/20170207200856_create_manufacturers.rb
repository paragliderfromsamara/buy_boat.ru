class CreateManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.string :www
      t.string :email
      t.string :phone
      t.string :logo
      t.integer :creator_id
      t.integer :updator_id

      t.timestamps
    end
  end
end

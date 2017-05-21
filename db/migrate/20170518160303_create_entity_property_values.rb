class CreateEntityPropertyValues < ActiveRecord::Migration[5.0]
  def change
    create_table :entity_property_values do |t|
      t.references :entity, polymorphic: true, index: true
      t.references :property_type, index: true
      t.integer :integer_value, default: 0
      t.float :float_value, default: 0.0
      t.string :string_value, default: ''
      t.boolean :bool_value, default: true
      t.boolean :is_binded, default: true
      t.string :tag, default: ''
    end
  end
end

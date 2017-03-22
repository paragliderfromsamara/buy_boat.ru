class CreateConfiguratorEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :configurator_entities do |t|
      t.integer :boat_type_id
      t.integer :boat_option_type_id
      t.integer :arr_id
      t.string :photo
      t.string :rec_type
      t.string :rec_level
      t.boolean :hidden, default: false
      t.boolean :group_hidden, default: false
      t.string :rec_fixed_invisibility, default: ""
      t.string :param_code, default: ""
      t.string :param_name, default: ""
      t.string :comment, default: ""
      t.string :nom_std_compl, default: ""
      t.boolean :checked, default: false
      t.string :level_checked, default: ""
      t.boolean :enabled, default: false
      t.boolean :start_enabled, default: false
      t.string :std_comp_sostav
      t.string :std_comp_option
      t.string :std_comp_select
      t.string :std_comp_enable
      t.string :std_comp_prefer
      t.string :sel_if_y, default: ""
      t.string :sel_if_n, default: ""
      t.string :de_sel_if_y, default: ""
      t.string :de_sel_if_n, default: ""
      t.string :dis_if_y, default: ""
      t.string :dis_if_n, default: ""
      t.string :en_if_y, default: ''
      t.string :en_if_n, default: ''
      t.integer :price, default: 0
      t.string :amount, default: ""
    end
  end
end

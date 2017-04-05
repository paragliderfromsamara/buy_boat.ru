class SelectedOption < ApplicationRecord
  belongs_to :boat_option_type, optional: true, validate: false
  belongs_to :boat_for_sale
  
  def self.default_scope
    order("arr_id ASC")
  end
  
  
  
  def name
    self.boat_option_type.nil? ?  self.param_name : boat_option_type.name
  end
  
end

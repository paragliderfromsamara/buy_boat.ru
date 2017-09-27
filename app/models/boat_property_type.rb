class BoatPropertyType < ApplicationRecord
  after_create :create_boat_property_values#, on: :create
  belongs_to :property_type
  def self.update_properties_list(boat_parameter_type_params)
     BoatPropertyType.delete_all
     BoatPropertyType.create(boat_parameter_type_params[:boats_property_types_attributes].values) if !boat_parameter_type_params[:boats_property_types_attributes].blank?
  end
  
  private
  
  def create_boat_property_values
    vals = []
    boat_types = BoatType.all
    boat_types.each {|bt| vals.push(bt.entity_property_values.build(property_type_id: self.property_type_id, set_ru_value: self.property_type.default_value, set_en_value: self.property_type.default_value, is_binded: false)) if bt.entity_property_values.find_by(property_type_id: self.property_type_id).blank? }
    vals.each {|v| v.save} if !vals.blank?
  end
end

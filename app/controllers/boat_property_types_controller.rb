class BoatPropertyTypesController < ApplicationController
  before_action :check_grants


  def index
    @boat_property_types = BoatType.property_types
    @property_types = PropertyType.for_select_list
    @title = @header = "Характеристики лодок"
  end

  def create
    BoatPropertyType.update_properties_list(boat_parameter_type_params)
    redirect_to boat_property_types_path#@boat_property_types = BoatProperty
  end
 
  private
    def check_grants
      redirect_to "/404" and return if !could_manage_boat_parameter_types? #defined in GrantsHelper
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_type_params
      params.require(:boat).permit(boats_property_types_attributes:[:property_type_id, :order_number])
    end
end

class PropertyTypesController < ApplicationController
  before_action :check_grants
  
  
  def index
    @title = @header = "Типы характеристик"
    @property_types = PropertyType.all.order("ru_name ASC")
    @value_types = PropertyType.value_types
  end
  
  def create
    @property_type = PropertyType.new(property_type_attr)
    if @property_type.save 
      render json: {status: :ok, property_type: @property_type}
    else
      render json: {status: :error, property_type: nil}
    end
  end
  
  def update
    @property_type = PropertyType.find(params[:id])
    if @property_type.update_attributes(property_type_attr)
      render json: {status: :ok, property_type: @property_type}
    else
      render json: {status: :error}
    end
  end
  
  def destroy
    @property_type = PropertyType.find(params[:id])
    if @property_type.destroy
      render json: {status: :ok}
    else
      render json: {status: :error}
    end
  end
  
  def copy_property_values
    if copy_params[:entity] == "product"
    else
      copy_boat_type_property_values
    end
  end
  
  private
  
  def copy_boat_type_property_values
    boat_type_from = BoatType.find_by(id: copy_params[:copy_from])
    boat_type_to = BoatType.find_by(id: copy_params[:copy_to])
    if !boat_type_from.nil? and !boat_type_to.nil?
      EntityPropertyValue.copy_properties_from(boat_type_from, boat_type_to)
      #render json: boat_type_from.property_values_hash.to_json
    end
    render json: boat_type_to.property_values_hash.to_json
  end
  
  def check_grants
    redirect_to "/404" if !is_producer? && !is_admin?
  end  
  
  def property_type_attr
    params.require(:property_type).permit(:name, :short_name, :measure, :value_type, :tag)
  end
  
  def copy_params
    params.require(:copy_entities).permit(:copy_from, :copy_to, :entity)
  end
end

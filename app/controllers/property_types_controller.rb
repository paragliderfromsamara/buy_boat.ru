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
  
  private
  
  def check_grants
    redirect_to "/404" if !is_producer?
  end  
  
  def property_type_attr
    params.require(:property_type).permit(:name, :short_name, :measure, :value_type, :tag)
  end
end

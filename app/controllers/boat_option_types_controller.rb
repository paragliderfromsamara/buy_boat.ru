class BoatOptionTypesController < ApplicationController
  before_action :set_boat_option_type, only: [:show, :update]
  before_action :check_grants
  def index
    @boat_option_types = BoatOptionType.order("param_code ASC").includes(:boat_types)
    @title = @header = "Типы опций"
  end
  
  def show 
    
  end
  
  def update
    respond_to do |format|
      if @boat_option_type.update_attributes(boat_option_type_params)
        format.html {redirect_to @boat_option_type}
      else
        format.html {render :show}
      end
    end
  end 
  
  private
  
  def boat_option_type_params
     params.require(:boat_option_type).permit(:name, :param_code, :description, :tag, :short_name)
  end
  
  def set_boat_option_type
    @boat_option_type = BoatOptionType.find(params[:id])
    @title = @header = @boat_option_type.name
  end
  
  def check_grants
    redirect_to "/404" if !is_manager?
  end
end

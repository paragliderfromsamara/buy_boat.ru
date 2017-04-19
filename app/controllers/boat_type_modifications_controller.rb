class BoatTypeModificationsController < ApplicationController
  before_action :check_grants, :set_boat_type_modification
  
  def edit
    
  end

  def update
    respond_to do |format|
      if @boat_type_modification.update_attributes(boat_type_modification_params)
        format.html{redirect_to %{#{edit_boat_type_path(@boat_type)}#modifications}}
      else
        format.html render "edit"
      end
    end
  end
  
  private
  
  def boat_type_modification_params
    params.require(:boat_type_modification).permit(:name, :description, :aft_view, :bow_view, :top_view, :accomodation_view)
  end
  
  def set_boat_type_modification
    @boat_type_modification = BoatTypeModification.find(params[:id])
    @boat_type = @boat_type_modification.boat_type
    @title = @header = "Изменение модификации #{@boat_type.catalog_name}"
  end
  
  def check_grants
    redirect_to "/404" if !is_producer?
  end
end

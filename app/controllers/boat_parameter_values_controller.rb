class BoatParameterValuesController < ApplicationController
  before_action :check_grants
  before_action :set_boat_parameter_value, only: [:update]

  # POST /boat_parameter_values
  # POST /boat_parameter_values.json
  def switch_bind
    boat = BoatType.find_by(id: params[:boat_type_id])
    redirect_to "/404" and return if boat.nil?
    value = boat.boat_parameter_values.find_by(id: params[:id])
    redirect_to "/404" and return if value.nil?
    value.update_attribute(:is_binded, !value.is_binded)
    render json: {status: :ok}
  end
  
  # PATCH/PUT /boat_parameter_values/1
  # PATCH/PUT /boat_parameter_values/1.json
  def update
    respond_to do |format|
      if @boat_parameter_value.update(boat_parameter_value_params)
        format.json { render json: {status: :ok, new_value: @boat_parameter_value.reload.get_value}}
      end
    end
  end


  private
    def check_grants
      redirect_to "/404" if !could_modify_boat_parameter_values?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_parameter_value
      @boat_parameter_value = BoatParameterValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_value_params
      params.require(:boat_parameter_value).permit(:set_value)
    end
end

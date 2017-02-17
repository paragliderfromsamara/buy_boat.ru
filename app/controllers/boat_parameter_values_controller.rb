class BoatParameterValuesController < ApplicationController
  before_action :check_grants
  before_action :set_boat_parameter_value, only: [:update, :switch_bind]

  # POST /boat_parameter_values
  # POST /boat_parameter_values.json
  def switch_bind
    boat = BoatType.find_by(id: params[:boat_type_id])
    redirect_to "/404" and return if boat.nil?
    redirect_to "/404" and return if @boat_parameter_value.boat_type_id != boat.id
    @boat_parameter_value.update_attribute(:is_binded, !@boat_parameter_value.is_binded)
    render json: {status: :ok}
  end
  
  # PATCH/PUT /boat_parameter_values/1
  # PATCH/PUT /boat_parameter_values/1.json
  def update
      if @boat_parameter_value.update(boat_parameter_value_params)
        render json: {status: :ok, new_value: @boat_parameter_value.reload.get_value}
      else
        render json: {status: :bad}
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

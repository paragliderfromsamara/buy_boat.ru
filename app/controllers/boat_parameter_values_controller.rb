class BoatParameterValuesController < ApplicationController
  before_action :set_boat_parameter_value, only: [:show, :edit, :update, :destroy]

  # GET /boat_parameter_values
  # GET /boat_parameter_values.json
  def index
    @boat_parameter_values = BoatParameterValue.all
  end

  # GET /boat_parameter_values/1
  # GET /boat_parameter_values/1.json
  def show
  end

  # GET /boat_parameter_values/new
  def new
    @boat_parameter_value = BoatParameterValue.new
  end

  # GET /boat_parameter_values/1/edit
  def edit
  end

  # POST /boat_parameter_values
  # POST /boat_parameter_values.json
  def create
    @boat_parameter_value = BoatParameterValue.new(boat_parameter_value_params)

    respond_to do |format|
      if @boat_parameter_value.save
        format.html { redirect_to @boat_parameter_value, notice: 'Boat parameter value was successfully created.' }
        format.json { render :show, status: :created, location: @boat_parameter_value }
      else
        format.html { render :new }
        format.json { render json: @boat_parameter_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_parameter_values/1
  # PATCH/PUT /boat_parameter_values/1.json
  def update
    respond_to do |format|
      if @boat_parameter_value.update(boat_parameter_value_params)
        format.html { redirect_to @boat_parameter_value, notice: 'Boat parameter value was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_parameter_value }
      else
        format.html { render :edit }
        format.json { render json: @boat_parameter_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_parameter_values/1
  # DELETE /boat_parameter_values/1.json
  def destroy
    @boat_parameter_value.destroy
    respond_to do |format|
      format.html { redirect_to boat_parameter_values_url, notice: 'Boat parameter value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_parameter_value
      @boat_parameter_value = BoatParameterValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_value_params
      params.require(:boat_parameter_value).permit(:boat_type_id, :boat_parameter_type_id, :bool_value, :integer_value, :float_value, :string_value)
    end
end

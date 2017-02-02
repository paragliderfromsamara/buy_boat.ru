class BoatParameterTypesController < ApplicationController
  before_action :set_boat_parameter_type, only: [:show, :edit, :update, :destroy]

  # GET /boat_parameter_types
  # GET /boat_parameter_types.json
  def index
    @boat_parameter_types = BoatParameterType.all
  end

  # GET /boat_parameter_types/1
  # GET /boat_parameter_types/1.json
  def show
  end

  # GET /boat_parameter_types/new
  def new
    @boat_parameter_type = BoatParameterType.new
  end

  # GET /boat_parameter_types/1/edit
  def edit
  end

  # POST /boat_parameter_types
  # POST /boat_parameter_types.json
  def create
    @boat_parameter_type = BoatParameterType.new(boat_parameter_type_params)

    respond_to do |format|
      if @boat_parameter_type.save
        format.html { redirect_to @boat_parameter_type, notice: 'Boat parameter type was successfully created.' }
        format.json { render :show, status: :created, location: @boat_parameter_type }
      else
        format.html { render :new }
        format.json { render json: @boat_parameter_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_parameter_types/1
  # PATCH/PUT /boat_parameter_types/1.json
  def update
    respond_to do |format|
      if @boat_parameter_type.update(boat_parameter_type_params)
        format.html { redirect_to @boat_parameter_type, notice: 'Boat parameter type was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_parameter_type }
      else
        format.html { render :edit }
        format.json { render json: @boat_parameter_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_parameter_types/1
  # DELETE /boat_parameter_types/1.json
  def destroy
    @boat_parameter_type.destroy
    respond_to do |format|
      format.html { redirect_to boat_parameter_types_url, notice: 'Boat parameter type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_parameter_type
      @boat_parameter_type = BoatParameterType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_type_params
      params.require(:boat_parameter_type).permit(:name, :short_name, :measure, :value_type)
    end
end

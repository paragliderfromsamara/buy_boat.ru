class BoatTypesController < ApplicationController
  before_action :set_boat_type, only: [:show, :edit, :update, :destroy]

  # GET /boat_types
  # GET /boat_types.json
  def index
    @boat_types = BoatType.all
  end

  # GET /boat_types/1
  # GET /boat_types/1.json
  def show
  end

  # GET /boat_types/new
  def new
    @boat_type = BoatType.new
  end

  # GET /boat_types/1/edit
  def edit
  end

  # POST /boat_types
  # POST /boat_types.json
  def create
    @boat_type = BoatType.new(boat_type_params)

    respond_to do |format|
      if @boat_type.save
        format.html { redirect_to @boat_type, notice: 'Boat type was successfully created.' }
        format.json { render :show, status: :created, location: @boat_type }
      else
        format.html { render :new }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_types/1
  # PATCH/PUT /boat_types/1.json
  def update
    respond_to do |format|
      if @boat_type.update(boat_type_params)
        format.html { redirect_to @boat_type, notice: 'Boat type was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_type }
      else
        format.html { render :edit }
        format.json { render json: @boat_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_types/1
  # DELETE /boat_types/1.json
  def destroy
    @boat_type.destroy
    respond_to do |format|
      format.html { redirect_to boat_types_url, notice: 'Boat type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_type
      @boat_type = BoatType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_type_params
      params.require(:boat_type).permit(:name, :series, :body_type, :description, :base_cost, :min_hp, :max_hp, :hull_width, :hull_length, :is_deprecated, :is_active, :creator_id, :modifier_id)
    end
end

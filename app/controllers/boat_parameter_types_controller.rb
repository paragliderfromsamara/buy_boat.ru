class BoatParameterTypesController < ApplicationController
  before_action :check_grants
  before_action :set_boat_parameter_type, only: [:edit, :update, :destroy]

  # GET /boat_parameter_types
  # GET /boat_parameter_types.json
  def index
    @boat_parameter_types = BoatParameterType.json_view
    @title = @header = "Таблица типов параметров"
  end


  # GET /boat_parameter_types/new
  def new
    @boat_parameter_type = BoatParameterType.new
    render layout: false if params[:nolayout] == "true" 
  end

  # GET /boat_parameter_types/1/edit
  def edit
    render layout: false if params[:nolayout] == "true" 
  end

  # POST /boat_parameter_types
  # POST /boat_parameter_types.json
  def create
    @boat_parameter_type = BoatParameterType.new(boat_parameter_type_params)

    respond_to do |format|
      if @boat_parameter_type.save
        format.html { redirect_to @boat_parameter_type, notice: 'Boat parameter type was successfully created.' }
        format.json { render :show, status: :created, location: @boat_parameter_type }
        format.js {render js: "Turbolinks.visit(window.location);"}
      else
        format.html { render :new }
        format.json { render json: @boat_parameter_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_numbers
    ids = upd = ""
    if !params.blank?
      BoatParameterType.all.each do |t|
        next if params["number_#{t.id}".to_sym].nil?
        t.update_attribute(:number, params["number_#{t.id}".to_sym])
        upd += "#{t.id}; "
      end
      upd = "no" if upd.blank?
      render json: {status: "#{upd}; #{ids}"}
    end
  end
  # PATCH/PUT /boat_parameter_types/1
  # PATCH/PUT /boat_parameter_types/1.json
  def update
    respond_to do |format|
      if @boat_parameter_type.update(boat_parameter_type_params)
        format.html { redirect_to @boat_parameter_type, notice: 'Boat parameter type was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_parameter_type }
        format.js {render js: "Turbolinks.visit(window.location);"}
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
      format.js {render js: "Turbolinks.visit(window.location);"}
    end
  end

  private
    def check_grants
      redirect_to "/404" if !could_edit_boat_parameter_types? #defined in GrantsHelper
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_parameter_type
      @boat_parameter_type = BoatParameterType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_type_params
      params.require(:boat_parameter_type).permit(:name, :short_name, :measure, :value_type, :is_use_on_filter)
    end
end

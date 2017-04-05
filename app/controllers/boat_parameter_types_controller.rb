class BoatParameterTypesController < ApplicationController
  before_action :check_grants
  before_action :set_boat_parameter_type, only: [:edit, :update, :destroy]

  # GET /boat_parameter_types
  # GET /boat_parameter_types.json
  def index
    @hide_slider = true
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
    @hide_slider = true
    @boat_parameter_type = BoatParameterType.new(boat_parameter_type_params)
    if @boat_parameter_type.save
      render js: "Turbolinks.visit(window.location);"
    else
      render js: "alert('Не удалось сохранить новый тип параметра');"
    end
  end
  
  def update_numbers
    if !params.blank?
      BoatParameterType.all.each do |t|
        next if params["number_#{t.id}".to_sym].nil?
        t.update_attribute(:number, params["number_#{t.id}".to_sym])
      end
      render json: {status: :ok}
    end
  end
  # PATCH/PUT /boat_parameter_types/1
  # PATCH/PUT /boat_parameter_types/1.json
  def update
      if @boat_parameter_type.update(boat_parameter_type_params)
        render js: "Turbolinks.visit(window.location);"
      else
        render js: "alert('Не удалось обновить тип параметра');"
      end  
  end

  # DELETE /boat_parameter_types/1
  # DELETE /boat_parameter_types/1.json
  def destroy
    @boat_parameter_type.destroy
    render js: "Turbolinks.visit(window.location);"
  end

  private
    def check_grants
      redirect_to "/404" and return if !could_manage_boat_parameter_types? #defined in GrantsHelper
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_parameter_type
      @boat_parameter_type = BoatParameterType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_parameter_type_params
      params.require(:boat_parameter_type).permit(:name, :short_name, :measure, :value_type, :is_use_on_filter, :tag)
    end
end

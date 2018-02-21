class BoatSeriesController < ApplicationController
  before_action :check_grants
  before_action :set_boat_series, only: [:show, :update, :destroy]
  
  # GET /boat_series
  # GET /boat_series.json
  def index
    @title = @header = "Серии лодок"
    @boat_series = BoatSeries.all.order("name ASC")
  end

  # GET /boat_series/1
  # GET /boat_series/1.json
  def show
  end

  # POST /boat_series
  # POST /boat_series.json
  def create
    @boat_series = BoatSeries.new(boat_series_params)
    #@title = @header = "Новая торговая марка"
    respond_to do |format|
      if @boat_series.save
        #format.html { redirect_to @boat_series, notice: 'Торговая марка успешно добавлена' }
        format.json { render json: @boat_series}
      else
        #format.html { render :new }
        format.json { render json: @boat_series.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_series/1
  # PATCH/PUT /boat_series/1.json
  def update
    #@title = @header = "Изменение торговой марки"
    respond_to do |format|
      if @boat_series.update(boat_series_params)
        #format.html { redirect_to @boat_series, notice: 'Торговая марка успешно изменена' }
        format.json { render json: @boat_series.to_json }
      else
        #format.html { render :edit }
        format.json { render json: @boat_series.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_series/1
  # DELETE /boat_series/1.json
  def destroy
    @boat_series.destroy
    respond_to do |format|
      #format.html { redirect_to boat_series_url, notice: 'boat_series was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  
  private
  
  def check_grants
    redirect_to "/404" if !could_manage_boat_series?
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_boat_series
    @boat_series = BoatSeries.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def boat_series_params
    params.require(:boat_series).permit(:name, :description)
  end
end

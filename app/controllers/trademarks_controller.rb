class TrademarksController < ApplicationController
  before_action :set_trademark, only: [:show, :update, :destroy]
  before_action :check_grants
  # GET /trademarks
  # GET /trademarks.json
  def index
    @title = @header = "Торговые марки"
    @trademarks = Trademark.all
  end

  # GET /trademarks/1
  # GET /trademarks/1.json
  def show
  end

  # POST /trademarks
  # POST /trademarks.json
  def create
    prms = trademark_params
    prms[:updater_id] = prms[:creator_id]= current_user.id
    @trademark = Trademark.new(prms)
    #@title = @header = "Новая торговая марка"
    respond_to do |format|
      if @trademark.save
        #format.html { redirect_to @trademark, notice: 'Торговая марка успешно добавлена' }
        format.json { render json: @trademark}
      else
        #format.html { render :new }
        format.json { render json: @trademark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trademarks/1
  # PATCH/PUT /trademarks/1.json
  def update
    #@title = @header = "Изменение торговой марки"
    prms = trademark_params
    prms[:updater_id] = current_user.id
    respond_to do |format|
      if @trademark.update(trademark_params)
        #format.html { redirect_to @trademark, notice: 'Торговая марка успешно изменена' }
        format.json { render json: @trademark.to_json }
      else
        #format.html { render :edit }
        format.json { render json: @trademark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trademarks/1
  # DELETE /trademarks/1.json
  def destroy
    @trademark.destroy
    respond_to do |format|
      #format.html { redirect_to trademarks_url, notice: 'trademark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def check_grants
      redirect_to "/404" if !could_manage_trademarks?
    end 
    
    # Use callbacks to share common setup or constraints between actions.
    def set_trademark
      @trademark = Trademark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trademark_params
      params.require(:trademark).permit(:name, :www, :email, :phone, :logo, :vertical_logo, :white_logo, :site_tag, :delete_logo, :creator_id, :updater_id)
    end
end

class BoatForSalesController < ApplicationController
  before_action :set_boat_for_sale, only: [:show, :update, :destroy]
  def index
    if params[:ids].nil?
      @boat_for_sales = BoatForSale.all.joins(:boat_type)
    else
      @boat_for_sales = BoatForSale.where(id: params[:ids]).joins(:boat_type)
    end
  end
  
  def show
    @boat_type = @boat_for_sale.boat_type
    @header = @boat_type.catalog_name
  end
  
  def update
    
  end
  
  def destroy
    @boat_for_sale.destroy
    respond_to do |format|
      format.html {redirect_to manage_boat_for_sales_path}
    end
    
  end
  
  def parse_selected_options_file
    @parsed_data = BoatForSale.parse_file(parser_options)
    if @parsed_data[:status] < 6 #если что-то пошло не так
      render json: @parsed_data
    else
      b = BoatForSale.create(boat_type_id: @parsed_data[:boat_type_id])
      b.reload
      b.update_attributes(selected_options_attributes: @parsed_data[:found].to_ass_hash)#если всё хорошо
      
      #b.selected_options.create(@parsed_data[:found])
      
      redirect_to manage_boat_for_sales_path
    end
  end

  def manage_index
    @title = @header = "Управление укомплектованными лодками"
    @boat_for_sales = BoatForSale.all
  end

  private
  
  def set_boat_for_sale
    @boat_for_sale = BoatForSale.find(params[:id])
  end

  def parser_options
    return nil if params[:boat_option_list].blank?
    params.require(:boat_option_list).permit(:option_list_file, :boat_type_id) 
  end
end

class BoatForSalesController < ApplicationController
  include BoatForSalesHelper
  before_action :set_boat_for_sale, only: [:update, :destroy, :buy]
  before_action :set_boat_filter_data, only: [:show, :index, :favorites]

  def buy
    
  end
  
  
  def favorites
    respond_to do |format|
      format.html {render "index"}
      format.json {render json: @boat_for_sales}
    end
  end
  def switch_favorites #вносит/удаляет из списка избанное
    bfs = BoatForSale.active.find_by(id: params[:id])
    if bfs.nil?
      render json: {status: :no_boat_in_list}
    else
      sts = switch_in_favorites(bfs.id)
      render json: {status: sts, favorites: BoatForSale.filtered_collection(get_favorites)}
    end
  end
  
  def index
      respond_to do |format|
        format.html 
        format.json {render json: @boat_for_sales}
      end
  end
  
  def show
    @boat_type = @boat_for_sale.boat_type
    @title = @boat_type.catalog_name
    respond_to do |format|
      format.html {render "index"}
      format.json {render json: @boat_for_sale.hash_view }
    end
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
      b = BoatForSale.create(boat_type_id: @parsed_data[:boat_type_id], shop_id: parser_options[:shop_id])
      b.reload
      b.update_attributes(selected_options_attributes: @parsed_data[:found].to_ass_hash)#если всё хорошо
      
      #b.selected_options.create(@parsed_data[:found])
      
      redirect_to manage_shop_path(parser_options[:shop_id])
    end
  end

  def manage_index
    @title = @header = "Управление укомплектованными лодками"
    @boat_for_sales = BoatForSale.all
  end
    
  private
  
  def set_boat_filter_data
    @filters_data = BoatForSale.filters(params) 
    ids = @filters_data[:filtered_ids] #@filters_data[:filtered_ids].blank? ? BoatForSale.active.ids : @filters_data[:filtered_ids]
    @boat_for_sales = BoatForSale.filtered_collection(ids) if params[:no_filtered_collection].nil? 
    @boat_for_sale = BoatForSale.find_by(id: params[:id])
    @favorites = BoatForSale.filtered_collection(get_favorites) if params[:no_filtered_collection].nil? 
  end
  
  def set_boat_for_sale
    @boat_for_sale = BoatForSale.find(params[:id])
  end

  def parser_options
    return nil if params[:boat_option_list].blank?
    params.require(:boat_option_list).permit(:option_list_file, :boat_type_id, :shop_id) 
  end
end

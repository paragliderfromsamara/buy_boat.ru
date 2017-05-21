class ShopsController < ApplicationController
  before_action :check_grants
  before_action :set_shop, only: [:change_status, :manage_show, :show, :boats_for_sale, :products, :add_product_to_shop]
  before_action :set_product_types, only: [:boats_for_sale, :products]
  
  def change_status #возможные статусы #to_open to_close to_disable
    #возможные статусы #to_enable to_open to_close to_disable
    #to_enable разрешено делать только производителям
    #to_disable разрешается делать только производителям
    #to_remove разрешается делать только производителям
    #to_open разрешено делать менеджерам и производителям
    #to_close разрешено делать менеджерам и производителям
    redirect_to "/404" if !could_modify_shop?
    to_status = params[:to_status]
    message = "Не удалось обновить статус магазина"
    if to_status == "to_enable" or to_status == "to_disable" and could_enable_or_disable_shop?
      if @shop.set_enable_status(to_status == "to_enable")
        message = to_status == "to_enable" ? "Магазин успешно активирован" : "Магазин успешно заблокирован"
      end
    elsif to_status == "to_open" or to_status == "to_close"
      if @shop.set_open_status(to_status == "to_open")
        message = to_status == "to_open" ? "Магазин успешно открыт" : "Магазин успешно закрыт"
      end
    elsif to_status == "to_remove" and could_destroy_shop?
      if @shop.destroy
        message = "Магазин успешно удалён из системы"
      end
    end
    render js: "alert('#{message}');Turbolinks.visit(window.location);"
  end
  
  def manage_index
    @title = @header = "Управление магазинами"
    @opened_shops = Shop.opened
    @closed_shops = Shop.closed
    @new_shops = Shop.recent
    @disabled_shops = Shop.disabled
  end
  
  def index
  end
  
  def show
    @boat_for_sales = BoatForSale.manage_collection(@shop.boat_for_sales.ids)
  end
  
  def boats_for_sale
    @boat_for_sales = BoatForSale.filtered_collection(@shop.boat_for_sales.ids)
  end
  
  def products
    @products = @shop.shop_products
    @product_type = ProductType.find(params[:product_type_id])
  end
  
  def add_product_to_shop
    @shop_product = @shop.shop_products.find_by(product_id: shop_product_params[:product_id])
    if @shop_product.nil?
      @shop_product = @shop.shop_products.build(shop_product_params)
      respond_to do |format|
        if @shop_product.save
          render json: {status: :ok}
        else
          render json: {status: :err}
        end
      end
    else
      respond_to do |format|
        if @shop_product.update_attributes(shop_product_params)
          render json: {status: :ok}
        else
          render json: {status: :err}
        end
      end
    end
    

  end
  
  def manage_show
    redirect_to manage_bfs_in_shop_path(@shop)
  end
  
  def create
    @shop = Shop.new(shop_params)
    respond_to do |format|
      if @shop.save
        format.js {render js: "Turbolinks.visit(window.location.href);" }  
      else
        
      end
    end

  end
  
  private
  def set_product_types
    @product_types = ProductType.not_draft
  end
  
  def set_shop
    @shop = Shop.find(params[:id])
    @title = @header = @shop.name
  end
  def check_grants
    redirect_to "/404" if !could_manage_all_shops?
  end
  
  def shop_product_params
    params.require(:shop_product).permit(:product_id, :amount)
  end
  
  def shop_params
    params.require(:shop).permit(:manager_id, :city_id, :street, :name, :phone_number_2, :phone_number_1)
  end
end

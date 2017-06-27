class ShopProductsController < ApplicationController
  before_action :set_shop_product, only: [:update, :destroy]
  before_action :check_grants, only: [:update, :destroy]
  
  def show
  end
  
  def create
    shop = Shop.find_by(id: shop_product_params[:shop_id])
    product = Product.find_by(id: shop_product_params[:product_id])
    if shop.nil? || product.nil?
      render js: "alert('Не указан товар или магазин!');"
    else
      redirect_to "/404" and return if !could_modify_shop?(shop)
      s_product = shop.shop_products.find_by(product_id: product.id)
      if s_product.nil?
        s_product = ShopProduct.new(shop_product_params)
        if s_product.save
          render js: "Turbolinks.visit(document.location);"
        else
          render js: "alert('Не удалось добавить товар в магазин!');"
        end  
      else
        render js: "alert('Данный товар уже добавлен в магазин!');"
      end
    end
  end
  
  def update
  end
  
  def destroy
    if @shop_product.destroy
      render js: "Turbolinks.visit(document.location);"
    else
      render js: "alert('Не удалось удалить товар из магазина!');"
    end
  end
  
  private
  
  def set_shop_product
    @shop_product = ShopProduct.find(params[:id])
    @shop = @shop_product.shop
  end
  def check_grants
    redirect_to "/404" if !could_modify_shop?
  end
  
  def shop_product_params
    params.require(:shop_product).permit(:product_id, :amount, :shop_id)
  end

end

class ProductsController < ApplicationController
  before_action :check_grants 
  before_action :set_product, only: [:edit, :destroy, :update, :photos, :show]
  def manage_index
    @title = @header = "Управление товарами"
  end
  
  def show
  end 
  
  def new
    @product_type = params[:product_type_id].blank? ? (ProductType.not_draft.first) : (ProductType.find_by(id: params[:product_type_id]))
    @title = @header = %{Добавление нового товара в категорию "#{@product_type.name}"}
    @product = Product.draft(@product_type)
  end
  
  def edit
    @title = @header = "Изменение товара"
  end
  
  def update
    p_params = product_params
    p_params[:is_draft] = false
    respond_to do |format|
      if @product.update_attributes(p_params) 
        format.html {redirect_to @product_type}
        format.json { render :show, status: :ok, location: @product }
      else
        @title = @header = "Добавление нового товара"
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.html {render :edit}
      end
    end
    
  end
  
  def destroy
    redirect_to @product.product_type if @product.destroy
  end
  
  private
  
  def check_grants
    redirect_to "/404" if !is_producer?
  end
  
  def set_product
    @product = Product.find(params[:id])
    @product_type = @product.product_type
  end
  
  def product_params
    params.require(:product).permit(:name, :description, :manufacturer, entity_property_values_attributes:[:property_type_id, :is_binded, :set_value, :tag], photos_attributes:[:link, :uploader_id])
  end
end

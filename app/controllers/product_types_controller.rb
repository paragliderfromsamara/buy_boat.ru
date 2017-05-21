class ProductTypesController < ApplicationController
  before_action :check_grants
  before_action :set_product_type, only: [:update, :destroy, :edit, :show]
  
  def show
    @title = %{Товары: #{@product_type.plural_name}}
    @product_types = ProductType.not_draft
    @products = @product_type.products
  end
  
  def manage_index
    product_type = ProductType.first
    redirect_to product_type_path(product_type) and return if !product_type.nil?
    @title = @header = "Управление типами товаров"
    
  end

  def create
    @product_type = ProductType.new(product_type_params)
    respond_to do |format|
      if @product_type.save
        format.html {redirect_to @product_type}
      else
        format.html {render "new"}
      end
    end
  end
  
  def new
    @title=@header="Новый тип товара"
    @product_type = ProductType.draft
  end
  
  def edit
    @title=@header="Изменение типа товара"
  end
  
  def update
    is_draft = @product_type.is_draft
    pt_params = product_type_params
    pt_params[:is_draft] = false
    respond_to do |format|
      if @product_type.update_attributes(product_type_params)
        format.html {redirect_to @product_type}
      else
        @title=@header= is_draft ? "Новый тип товара" : "Изменение типа товара"
        format.html {render is_draft ? "new" : "edit"}
      end
    end
    
  end
  
  def destroy
    @product_type.destroy
    redirect_to manage_product_types_path
  end
  
  private
  
  def check_grants
    redirect_to "/404" if !is_admin?
  end
  
  def product_type_params
    params.require(:product_type).permit(:name, :plural_name, :number_on_boat, :is_active, :description, product_types_property_types_attributes:[:property_type_id, :is_required, :order_number])
  end
  
  def set_product_type
    @product_type = ProductType.find(params[:id])
  end
end

class Shop < ApplicationRecord
  belongs_to :manager, class_name: "User"
  belongs_to :city
  has_many :boat_for_sales, dependent: :destroy
  has_many :shop_products, dependent: :delete_all
  
  
  def products(product_type_id=nil)
   if product_type_id.nil? 
     shop_products.joins(:product).order("products.name ASC")
   else
     shop_products.joins(:product).where("products.product_type_id = #{product_type_id}").order("products.name ASC")
   end
  end
 
  
  def all_products
    Product.where(id: shop_products.pluck(:product_id))
  end
  
  def region_location
    %{#{city.region.name}, #{city.name}}
  end
  
  def full_location
    %{#{city.country.name}\n #{city.region.name} \n #{city.name} \n #{street}}
  end
  
  def name_with_location
    %(#{name} (#{city.region.name}, #{city.name}))
  end
  
  def self.opened #открытые
    where(is_active: true, is_opened: true)
  end
  
  def self.closed #закрытые
    where(is_active: true, is_opened: false)
  end
  
  def self.recent #недавно добавленные
    where(is_active: false, is_opened: true)
  end
  
  def self.disabled #заблокированные магазины
    where(is_active: false, is_opened: false)
  end
  #проверяет закрыт ли магазин
  def is_opened? 
    is_active && is_opened
  end
  
  def is_closed?
    is_active && !is_opened
  end
  
  def is_recent?
    !is_active && is_opened
  end
  
  def is_disabled? #проверяем заблокирован ли магазин
    !is_opened? && !is_closed?
  end
  
  def available_product_types
    ProductType.where(id: shop_products.joins(:product).select("products.product_type_id AS product_type_id").pluck(:product_type_id)).select(:id, :name, :number_on_boat).distinct
  end
  
  def hash_view
    {id: id, name: name, location: full_location, product_types: available_product_types}
  end
  
  def set_enable_status(status = true) #управляет статусами доступности менеджеру
    self.update_attributes(is_opened: status, is_active: status)
  end
  
  def set_open_status(status = true)
    return false if !is_opened? and !is_recent? and !is_closed?
    return self.update_attribute(:is_opened, status)
  end
  

end

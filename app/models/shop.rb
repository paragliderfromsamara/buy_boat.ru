class Shop < ApplicationRecord
  belongs_to :manager, class_name: "User"
  belongs_to :city
  has_many :boat_for_sales, dependent: :destroy

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
  

  
  def set_enable_status(status = true) #управляет статусами доступности менеджеру
    self.update_attributes(is_opened: status, is_active: status)
  end
  
  def set_open_status(status = true)
    return false if !is_opened? and !is_recent? and !is_closed?
    return self.update_attribute(:is_opened, status)
  end
  

end

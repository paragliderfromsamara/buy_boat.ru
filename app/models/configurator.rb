class Configurator < ApplicationRecord
  self.abstract_class = true
  
  def self.rec_types #все типы 
    {
      group: "Группа",
      standart: "Стандарт",
      option: "ВЫБОР"
    }
  end
  

  
  def self.rec_type_group
    Configurator.rec_types[:group]
  end
  
  def self.rec_type_standart
    Configurator.rec_types[:standart]
  end
  
  def self.rec_type_option
    Configurator.rec_types[:option]
  end
  
  def is_group?
    self.rec_type == Configurator.rec_types[:group]
  end
  
  def is_standart?
    self.rec_type == Configurator.rec_types[:standart]
  end
  
  def is_option?
    self.rec_type == Configurator.rec_types[:option]
  end
  

end

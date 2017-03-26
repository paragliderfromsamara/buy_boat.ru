class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def id_as_code(n=7) # преобразует id объекта в число типа 000001
    (self.id.to_s.length >= 7) ? self.id.to_s : "#{"0"*(n - self.id.to_s.length)}#{self.id}" 
  end

end

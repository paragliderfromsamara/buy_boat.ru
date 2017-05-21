class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def id_as_code(n=7) # преобразует id объекта в число типа 000001
    (self.id.to_s.length >= 7) ? self.id.to_s : "#{"0"*(n - self.id.to_s.length)}#{self.id}" 
  end
  
  def split_by_locale(t) # текст должен выглядеть вот так: "русский {english}"
    reg = /\{(.+)\} ?/
    v = {com: '', ru: ''}
    return v if t.blank?
    i = t.index(reg)
    if !i.nil?
      t.gsub(reg) do |t|
        v[:com] = $1
      end
      v[:ru] = t[0..i-1] if i > 0
    else
      v[:ru] = t
    end
    return v
  end
  
  def attr_by_locale(a, locale = "ru") #достает атрибут из таблицы по локали и названию атрибута
    return nil if !has_attribute?("#{locale}_#{a}".to_sym)
    return self["#{locale}_#{a}".to_sym]
  end
end

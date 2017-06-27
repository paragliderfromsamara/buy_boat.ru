#Сюда добавляются дополнительные функции для базовых классов

class Array
  def to_ass_hash
    return {} if self.blank?
    v = {}
    self.each_index {|i| v[i.to_s.to_sym] = self[i]}
    return v
  end
end

class BoatSeries < ApplicationRecord
  validate :name_presence, :name_uniqueness
  
  def name_presence
    msg = "Серия не может быть без названия"
    if new_record?
      errors.add(:name, msg) if name.blank?  
    else
      errors.add(:name, msg) if name.blank? && !name.nil?
    end
  end
  
  
  def name_uniqueness
    return if name.nil?
    msg = "Серия с названием #{name} уже существует"
    names = name.blank? ? [] : BoatSeries.where.not(id: id).pluck(:name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
    errors.add(:name, msg) if !names.index(name.mb_chars.downcase.to_s.strip).nil?
  end
end

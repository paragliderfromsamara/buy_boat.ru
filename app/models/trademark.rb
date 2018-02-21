class Trademark < ApplicationRecord
  attr_accessor :logo_cache, :vertical_logo_cache, :white_logo_cache, :delete_logo

  
  before_save :check_logo_del_flag
  
  validate :name_presence, :name_uniqueness
  
  has_many :boat_types, dependent: :destroy

  mount_uploader :logo, LogoUploader
  mount_uploader :vertical_logo, LogoUploader
  mount_uploader :white_logo, LogoUploader
  
  def hash_view
    {
      id: self.id,
      name: self.name,
      logo: sorted_logo(self.logo),
      vertical_logo: sorted_logo(self.vertical_logo),
      white_logo: sorted_logo(self.white_logo)
    }
  end
  
  def name_presence
    msg = "Торговая марка не может быть без названия"
    if new_record?
      errors.add(:name, msg) if name.blank?  
    else
      errors.add(:name, msg) if name.blank? && !name.nil?
    end
  end
  
  
  def name_uniqueness
    return if name.nil?
    msg = "Торговая марка #{name} уже существует"
    names = name.blank? ? [] : Trademark.where.not(id: id).pluck(:name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
    errors.add(:name, msg) if !names.index(name.mb_chars.downcase.to_s.strip).nil?
  end
  
  private
  #удаление логотипа если пришел флаг
  def check_logo_del_flag
    return if delete_logo.blank?
    case delete_logo
    when 'white_logo'
      self.remove_white_logo!
    when 'vertical_logo'
      self.remove_vertical_logo!
    when 'logo'
      self.remove_logo!
    end
  end
  
  def sorted_logo(l)
    return nil if l.nil?
    return {
      small: l.small.url, 
      medium: l.medium.url,
      large: l.large.url
    }
  end
end

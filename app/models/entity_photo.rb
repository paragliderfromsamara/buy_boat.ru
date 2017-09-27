class EntityPhoto < ApplicationRecord
  attr_accessor :skip_check_main
  belongs_to :entity, polymorphic: true
  belongs_to :photo
  after_destroy :destroy_photo_if_not_use
  after_save :check_main               #проверяем не изменился ли флаг is_main
  before_save :check_last_entity_photo #проверяем не является ли данный экземпляр послдним entity_photo на объекте 
  def self.default_scope
    order('id DESC')
  end
  
  #Выбирает главную фотографию из списка
  def self.main_photo(entity)
    return nil if entity.entity_photos.blank?
    ph = entity.entity_photos.find_by(is_main: true)
    if ph.nil?
      entity.entity_photos.first.photo
    else
      ph.photo
    end
  end
  
  def hash_view
    ph = self.photo.hash_view
    ph[:entity_photo_id] = self.id
    ph[:is_main] = self.is_main
    ph[:is_slider] = self.is_slider
    return ph
  end
  
  private
  
  def entity_has_main?
    entity.entity_photos.where(is_main: true).size > 0
  end
  
  def check_last_entity_photo
    return if new_record? || skip_check_main || !is_main_changed?
    if entity.entity_photos.size == 1
      self.is_main = true 
    end
    
  end
  
  def check_main
    return if new_record? || skip_check_main || !is_main_changed?
    if is_main 
      entity.entity_photos.each do |ep|
        ep.update_attributes(is_main: false, skip_check_main: true) if ep.id != self.id && ep.is_main
      end 
    else
      set_default_main
    end
    #is_main_changed? 
  end
  
  def set_default_main
    f = true
    entity.entity_photos.each do |ep|
      if ep != self && f
        f = !f
        ep.update_attributes(is_main: true, skip_check_main: true) if ep.id != self.id && !ep.is_main
      elsif ep != self && !f 
        ep.update_attributes(is_main: false, skip_check_main: true) if ep.id != self.id && ep.is_main
      end
    end 
  end
  
  def destroy_photo_if_not_use #удаляем неиспользуемые фотографии
    self.photo.destroy if self.photo.entity_photos.blank?
    set_default_main if !entity_has_main?
  end
  
end

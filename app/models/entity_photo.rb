class EntityPhoto < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :photo
  after_destroy :destroy_photo_if_not_use
  
  def self.default_scope
    order('id DESC')
  end
  
  def hash_view
    ph = self.photo.hash_view
    ph[:is_main] = self.is_main
    ph[:is_slider] = self.is_slider
    return ph
  end
  
  private
  
  def destroy_photo_if_not_use #удаляем неиспользуемые фотографии
    self.photo.destroy if self.photo.entity_photos.blank?
  end
  
end

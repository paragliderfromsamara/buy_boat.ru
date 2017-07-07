class EntityPhoto < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :photo
  after_destroy :destroy_photo_if_not_use
  
  private
  
  def destroy_photo_if_not_use #удаляем неиспользуемые фотографии
    self.photo.destroy if self.photo.entity_photos.blank?
  end
  
end

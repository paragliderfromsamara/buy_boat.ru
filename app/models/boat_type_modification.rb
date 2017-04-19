class BoatTypeModification < ApplicationRecord
  attr_accessor :aft_view_cache, :bow_view_cache, :top_view_cache, :accomodation_view
  belongs_to :boat_type
  belongs_to :boat_option_type
  
  mount_uploader :aft_view, ModificationViewsUploader
  mount_uploader :bow_view, ModificationViewsUploader
  mount_uploader :top_view, ModificationViewsUploader
  mount_uploader :accomodation_view, ModificationViewsUploader
  
  def set_activity_flag(f)
    self.update_attribute(:is_active, f) if self.is_active == !f
  end
  
  private
  

end

class BoatTypeModification < ApplicationRecord
  attr_accessor :aft_view_cache, :bow_view_cache, :top_view_cache, :accomodation_view_1_cache, :accomodation_view_2_cache, :accomodation_view_3_cache
  belongs_to :boat_type
  belongs_to :boat_option_type
  
  mount_uploader :aft_view, ModificationViewsUploader
  mount_uploader :bow_view, ModificationViewsUploader
  mount_uploader :top_view, ModificationViewsUploader
  mount_uploader :accomodation_view_1, ModificationViewsUploader
  mount_uploader :accomodation_view_2, ModificationViewsUploader
  mount_uploader :accomodation_view_3, ModificationViewsUploader
  
  def set_activity_flag(f)
    self.update_attribute(:is_active, f) if self.is_active == !f
  end
  
  def hash_view(locale='ru')
    {
      id: id,
      name: self["#{locale}_name".to_sym],
      description: self["#{locale}_description".to_sym],
      boat_option_type_id: boat_option_type.id,
      is_active: is_active,
      views: { 
                aft: get_mdf_views(aft_view),
                bow: get_mdf_views(bow_view),
                top: get_mdf_views(top_view),
                accomodations: accomodation_views
             }
    }
  end
  
  def accomodation_views
    views = []
    views.push get_mdf_views(accomodation_view_1) if !accomodation_view_1.url.nil?
    views.push get_mdf_views(accomodation_view_2) if !accomodation_view_2.url.nil?
    views.push get_mdf_views(accomodation_view_3) if !accomodation_view_3.url.nil?
    return views
  end
  
  private
  
  def get_mdf_views(view)
    view.url.nil? ? nil : {small: view.small.url, medium: view.medium.url, large: view.large.url} 
  end
  


end

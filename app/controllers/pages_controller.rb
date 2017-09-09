class PagesController < ApplicationController
  before_action :get_on_tm_site_boat_types
  
  
  def index
  
  end
  
  def about
  end
  
  def contacts
  end
  
  def boats
  end
  
  def boat
  end
  
  def test_page
    #BoatType.all.each do |bt|
    #  bt.boat_photos.each do |bp|
    #    bt.entity_photos.create(photo_id: bp.photo_id)
    #  end
    #end
    #Photo.all.each do |photo|
    #  photo.link.recreate_versions!(:thumb_square) if !photo.link.blank?
    #end
    
  end
  
  
  private 
  
  def get_on_tm_site_boat_types 
    @boat_types = BoatType.on_tm_site_boats(current_site)
  end
  
end

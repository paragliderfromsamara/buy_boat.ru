class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :destroy]
  before_action :check_grants, only: [:destroy, :destroy_on_entity]
  before_action :set_entity, only: [:destroy_on_entity, :entity_photos]
  def show
  end
  
  def entity_photos
    photos = @entity.nil? ? [] : @entity.photos.map {|ph| ph.hash_view}
    render json: photos
  end
  
  def destroy_on_entity
    @entity_photo = @entity.entity_photos.find_by(photo_id: params[:id])
    return if @entity_photo.nil?
    @entity_photo.destroy
    render js: "$('[data-photo-id=#{@entity_photo.photo_id}]').parent('.column').fadeOut(300, function(){$(this).remove();});"
  end
  
  private
  
  def check_grants
    redirect_to "/404" if !could_destroy_photo?
  end
   
  def set_photo
    @photo = Photo.find(params[:photo])
  end
  
  def set_entity
    return nil if params[:entity].blank? or params[:entity_id].blank?
    @entity = params[:entity] == "boat_type" ? BoatType.find_by(id: params[:entity_id]) : Product.find_by(id: params[:entity_id])
  end
end

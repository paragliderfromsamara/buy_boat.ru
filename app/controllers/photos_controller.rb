class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :destroy]
  before_action :check_grants, only: [:destroy, :destroy_on_entity, :upload, :update_entity_photo]
  before_action :set_entity, only: [:destroy_on_entity, :entity_photos, :upload, :update_entity_photo]
  def show
  end
  
  def upload
    @photo = Photo.new(photo_params)
    respond_to do |format|
      if @photo.save
        @entity.photos << @photo
        format.json { render :entity_photos, status: :created }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_entity_photo
    @entity_photo = @entity.entity_photos.find_by(photo_id: params[:id])
    respond_to do |format|
      if !@entity_photo.nil?
        @entity_photo.update_attributes(entity_photo_params)
        format.json { render :entity_photos }
      else
        format.json { render json: {message: "Фотография не найдена"}, status: :unprocessable_entity }
      end
    end
  end
  
  def entity_photos
    photos = @entity.nil? ? [] : @entity.entity_photos.map {|ep| ep.hash_view}
    render json: photos
  end
  
  def destroy_on_entity
    @entity_photo = @entity.entity_photos.find_by(photo_id: params[:id])
    respond_to do |format|
      if !@entity_photo.nil?
        @entity_photo.destroy
        format.json { head :no_content }
      else
        format.json { render json: {message: "Фотография не найдена"}, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def entity_photo_params
    params.require(:entity_photo).permit(:is_main, :is_slider)
  end
  
  def photo_params
    params.require(:photo).permit(:link, :is_slider)
  end
  
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

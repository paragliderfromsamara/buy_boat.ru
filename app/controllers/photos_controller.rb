class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :destroy]
  before_action :check_grants, only: [:destroy, :destroy_on_entity, :upload, :update_entity_photo]
  before_action :set_entity_photo, only: [:update_entity_photo, :destroy_entity_photo]
  before_action :set_entity, only: [:entity_photos, :upload]
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
   
  def entity_photos
    photos = @entity.nil? ? [] : @entity.entity_photos.map {|ep| ep.hash_view}
    render json: photos
  end
  
  def update_entity_photo #/entity_photos/:id :PUT
    respond_to do |format|
      if !@entity_photo.nil?
        @entity_photo.update_attributes(entity_photo_params)
        @entity = @entity_photo.entity
        @entity.entity_photos.reload
        format.json { render :entity_photos }
      else
        format.json { render json: {message: "Фотография не найдена"}, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy_entity_photo # /entity_photos/:id :DELETE
    respond_to do |format|
      if !@entity_photo.nil?
        @entity = @entity_photo.entity
        @entity_photo.destroy
        format.json { render :entity_photos }
      else
        format.json { render json: {message: "Фотография не найдена #{params[:id]}"}, status: :unprocessable_entity }
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
  
  def set_entity_photo
    @entity_photo = EntityPhoto.find(params[:id])
  end
  
  def set_entity
    return nil if params[:entity].blank? or params[:entity_id].blank?
    @entity = params[:entity] == "boat_type" ? BoatType.find_by(id: params[:entity_id]) : Product.find_by(id: params[:entity_id])
  end
end

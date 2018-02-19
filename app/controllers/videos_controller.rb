class VideosController < ApplicationController
  before_action :check_grants
  def create
    video = BoatVideo.new(video_params)
    respond_to do |format|
      if video.save
        format.json {render json: video, status: :ok }
      else
        format.json {render json: {message: 'Не удалось обновить таблицу характеристик'}, status: :unprocessable_entity }
      end
    end 
  end

  def destroy
    video = BoatVideo.find(params[:id])
    video.destroy
    respond_to do |format|
      format.json {render json: {status: :ok}, status: :ok }
    end 
  end
  
  private 
  
  def check_grants
    redirect_to "/404" if !could_manage_boat_types? || !is_control?
  end
  
  def video_params
    params.require(:boat_video).permit(:boat_type_id, :url)
  end
end

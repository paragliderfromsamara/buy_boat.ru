class RealcraftPagesController < ApplicationController
  include RealcraftHelper 
  before_action :check_request_forms, only: [:send_boat_request, :send_dealer_request]
  
  def index
  end

  def prices
    @title = t(:prices)
  end
  
  def dealers
    @title = t(:dealers)
  end
  
  def about
    @title = t(:about)
  end
  
  def realcraft_190
    @boat = real_craft_190
    @title = @boat[:name]
    @page_image = '/slider/rc190/2_xlarge.jpg'
    @meta_content = @boat["slogan_#{cur_locale}".to_sym]
  end

  def realcraft_200
    @boat = real_craft_200
    @title = @boat[:name]
    @page_image = '/slider/rc200/4_slider_xlarge.jpg'
    @meta_content = @boat["slogan_#{cur_locale}".to_sym]
  end
  
  def send_boat_request
    #redirect_to "/404" if params[:boat_request].blank?
    render js: %{$("#success-request").show();} if RequestsMailer.boat_request(boat_request_params).deliver_now && RequestsMailer.boat_request(boat_request_params, "romankozvonin@gmail.com").deliver_now
  end
  
  def send_dealer_request
    #redirect_to "/404" if params[:dealer_request].blank?
    render js: %{$("#success-request").show();} if RequestsMailer.dealer_request(dealer_request_params).deliver_now && RequestsMailer.dealer_request(dealer_request_params, "romankozvonin@gmail.com").deliver_now
  end
  
  def please_wait
    #redirect_to root_path if (cur_locale == "ru" && $enable_ru_locale) || (cur_locale == "en" && $enable_en_locale) 
  end
  
  private 
  
  def check_request_forms
    f = false
    if !params[:boat_request].blank?
      f = !params[:boat_request][:email].blank? && !params[:boat_request][:name].blank? 
    else !params[:dealer_request].blank?
      f = !params[:dealer_request][:email].blank? && !params[:dealer_request][:name].blank? 
    end
    redirect_to "/404" if !f
  end
  
  def boat_request_params
    params.require(:boat_request).permit(:name, :email, :boat_name, :comment)
  end
  
  def dealer_request_params
    params.require(:dealer_request).permit(:name, :email, :comment)
  end
end

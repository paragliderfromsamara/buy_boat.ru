class BoatSeriesController < ApplicationController
  def index
  end
  
  private
  
  def check_grants
    redirect_to "/404" if !could_manage_boat_series?
  end
end

class LocationsController < ApplicationController
  def regions
    country = Country.find(params[:country_id])
    @regions = country.regions
  end
  
  def cities
    region = Region.find(params[:region_id])
    @cities = region.cities
  end
  
  def add_country
    if !params[:country].blank? 
      Country.add_country(params[:country][:name])
      redirect_to "/add_country"
    end
    @countries = Country.order("name ASC")
  end
end

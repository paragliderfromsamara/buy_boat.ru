class LocationsController < ApplicationController
  def regions
    country = Country.find(params[:country_id])
    @regions = country.regions
  end
  
  def cities
    region = Region.find(params[:region_id])
    @cities = region.cities
  end
end

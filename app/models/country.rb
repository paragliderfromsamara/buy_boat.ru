class Country < ApplicationRecord
  has_many :regions, dependent: :destroy
  has_many :cities, through: :regions
  
  def self.locations_file_path
     Rails.root.join("public", "world_countries_regions_cities_utf.xml")
  end
  
  def self.location_file
    return nil if !Country.locations_file_exists?
    return Nokogiri::XML(File.open(Country.locations_file_path), nil, 'utf-8')
  end
  
  def self.locations_file_exists?
    File.exists?(Country.locations_file_path)
  end
  
  def self.countries_list 
    loaded_countries = all.pluck(:name)
    doc = Country.location_file
    return [] if doc.nil?
    countries_xml = doc.xpath("//country")
    countries = []
    countries_xml.each {|c| countries[countries.length] = c.xpath("name")[0].content if loaded_countries.index(c.xpath("name")[0].content).nil?}
    return countries
  end
  
  def self.add_country(name)
    country = Country.find_by(name: name)
    return if !country.nil?
    doc = Country.location_file
    return if doc.nil?
    countries = doc.xpath("//country")
    countries.each do |country|
      country_name = country.xpath("name")[0].content
      next if country_name != name
      country_id = country.xpath("country_id")[0].content
      c = Country.create(name: country_name)
      c.reload
      regions = doc.xpath("//region")
      regions.each do |region|
        next if region.xpath("country_id")[0].content != country_id
        region_id = region.xpath("region_id")[0].content
        r = c.regions.create(name: region.xpath("name")[0].content)
        r.reload
        cities_xml = doc.xpath("//city")
        cities = []
        cities_xml.each do |city|
          next if city.xpath("region_id")[0].content != region_id || city.xpath("country_id")[0].content != country_id
          cities.push({name: city.xpath("name")[0].content})
        end
        r.cities.create(cities)
      end
      break 
    end
    return "Страна #{name} успешно загружена."
  end
  
  private 
  
  def get_contries_from_list 
    
  end
  
  def country_file_location
   Rails.root.join("public", "world_countries_regions_cities_utf.xml")
  end
end

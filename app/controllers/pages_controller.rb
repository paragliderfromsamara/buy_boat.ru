class PagesController < ApplicationController
  def index
    
  end
  
  def boat_type_import
    @additionScript = "http://salut-boats.ru/config_scripts/data_salut480mpro.js"
  end
end

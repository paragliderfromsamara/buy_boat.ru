class BoatOptionTypesController < ApplicationController
  def index
    @boat_option_types = BoatOptionType.order("param_code ASC")
    @title = @header = "Типы опций"
  end
end

class BoatOptionType < Configurator
  has_many :configurator_entities, dependent: :delete_all
  has_many :selected_options, dependent: :delete_all
  
  
  
end

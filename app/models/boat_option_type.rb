class BoatOptionType < Configurator
  has_many :configurator_entities, dependent: :delete_all
  has_many :selected_options, dependent: :delete_all
  has_many :boat_types, through: :configurator_entities
  has_many :boat_for_sales, through: :selected_options
  
  def self.transoms #транцы
    where(tag: "transom")
  end
  
  def self.transom_filter_data(active_bfs_ids)
    transoms = BoatOptionType.transoms
    return [] if transoms.blank?
    return transoms.map{|t| {id: t.id, name: t.s_name}}
  end
  
  def boat_types_where_it_uses
    self.boat_types.distinct
  end
  
  def s_name #создана для вывода сокращенного имени 
    short_name.blank? ? name : short_name 
  end
end

class BoatOptionType < Configurator
  has_many :configurator_entities, dependent: :delete_all
  has_many :selected_options, dependent: :delete_all
  has_many :boat_types, through: :configurator_entities
  has_many :boat_for_sales, through: :selected_options
  def self.filter_data
    filterItems = {}
    where(tag: ["transom"]).includes(:boat_for_sales).each{|t| filterItems[t.tag.to_sym] = {
                                                                                    name: t.name, 
                                                                                    values: t.boat_for_sales.to_a.map{|v| {b_id: v.boat_type_id, bfs_id: v.id}}
                                                                                }} 
   return filterItems
  end
  
  def boat_types_where_it_uses
    self.boat_types.distinct
  end
end

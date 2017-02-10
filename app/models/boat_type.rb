class BoatType < ApplicationRecord
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  belongs_to :boat_series
  belongs_to :trademark
  
  def self.body_types
    select(:body_type).order("body_type ASC").uniq.map{|bt| bt.body_type if !bt.body_type.blank?}
  end
  
  def self.max_hp
    select(:max_hp).order("max_hp ASC").uniq.map{|bt| bt.max_hp if !bt.max_hp.blank?}
  end
  
  def self.min_hp
    select(:min_hp).order("min_hp ASC").uniq.map{|bt| bt.min_hp if !bt.min_hp.blank?}
  end
  
  def self.hull_width
    select(:hull_width).order("hull_width ASC").uniq.map{|bt| bt.hull_width if !bt.hull_width.blank?}
  end
  
  def self.hull_length
    select(:hull_length).order("hull_length ASC").uniq.map{|bt| bt.hull_length if !bt.hull_length.blank?}
  end
  
  def catalog_name
    %{#{self.trademark.name}#{%{ #{self.boat_series.name}} if !self.boat_series.nil?} #{self.body_type}}
  end
end

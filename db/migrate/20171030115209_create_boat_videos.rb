class CreateBoatVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_videos do |t|
      t.integer :boat_type_id
      t.string :url

      t.timestamps
    end
  end
end

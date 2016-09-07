class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :description
      t.integer :user_id
    end
  end
end

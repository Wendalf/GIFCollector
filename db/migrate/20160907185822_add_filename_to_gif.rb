class AddFilenameToGif < ActiveRecord::Migration
  def change
    add_column :gifs, :filename, :string
  end
end

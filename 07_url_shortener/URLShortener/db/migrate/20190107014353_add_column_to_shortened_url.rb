class AddColumnToShortenedUrl < ActiveRecord::Migration[5.2]
  def change
	add_column :shortened_urls, :user_id, :integer, null: false
  end
end

class AddTimestampsToShortenedUrl < ActiveRecord::Migration[5.2]
  def change
	add_column :shortened_urls, :created_at, :timestamp
	add_column :shortened_urls, :updated_at, :timestamp
  end
end

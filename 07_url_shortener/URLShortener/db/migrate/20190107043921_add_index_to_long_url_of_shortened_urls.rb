class AddIndexToLongUrlOfShortenedUrls < ActiveRecord::Migration[5.2]
  def change
	add_index :shortened_urls, :short_url
  end
end

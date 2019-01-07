class TagTopic < ApplicationRecord

	validates :name, presence: true, uniqueness: true

	has_many :taggings,
		primary_key: :id,
		foreign_key: :tag_topic_id,
		class_name: :Tagging

	has_many :shortened_urls,
		through: :taggings,
		source: :shortened_url

	def popular_links
		self.shortened_urls.map { |x|  [x, x.num_clicks]   }.sort_by { |x| x[-1] * -1  }[0..4]
	end

end
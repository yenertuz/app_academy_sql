class Visit < ApplicationRecord

	validates :user_id, presence: true
	validates :shortened_url_id, presence: true

	belongs_to :user,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User

	belongs_to :shortened_url,
		primary_key: :id,
		foreign_key: :shortened_url_id,
		class_name: :ShortenedUrl

	def self.record_visit!(user, shortened_url)
		raise ArgumentError.new "#{user} is not a User object" unless user.is_a?(User)
		raise ArgumentError.new "#{shortened_url} is not a ShortenedUrl object" unless shortened_url.is_a?(ShortenedUrl)
		Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id)
	end

end
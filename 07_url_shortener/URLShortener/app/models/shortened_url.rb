class ShortenedUrl < ApplicationRecord
	validates :long_url, presence: true, uniqueness: true
	validates :user_id, presence: true


	belongs_to :submitter,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User


	def self.random_code
		to_try = SecureRandom::urlsafe_base64
		while self.exists?(short_url: to_try) == true
			to_try = SecureRandom::urlsafe_base64
		end
		to_try
	end

	def self.create_shortened_url(user, long_url)
		raise ArgumentError.new "#{user} is not a User object" if user.is_a?(User) == false
		raise ArgumentError.new "#{long_url} is not a string" if long_url.is_a?(String) == false
		ShortenedUrl.create!(user_id: user.id, long_url: long_url)
	end

end
class ShortenedUrl < ApplicationRecord
	validates :long_url, presence: true, uniqueness: true
	validates :user_id, presence: true


	belongs_to :submitter,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User

	has_many :visits,
		primary_key: :id,
		foreign_key: :shortened_url_id,
		class_name: :Visit

	has_many :visitors,
		through: :visits,
		source: :user

	has_many :distinct_visitors,
		-> { distinct  },
		through: :visits,
		source: :user


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
		short_url = ShortenedUrl.random_code
		ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: short_url)
	end

	def num_clicks
		self.visits.count(:id)
	end

	def num_uniques
		self.distinct_visitors.count(:user_id)
	end

	def num_recent_uniques
		self.distinct_visitors.where("visits.created_at > ? ", 30.minutes.ago).count(:user_id)
	end

end
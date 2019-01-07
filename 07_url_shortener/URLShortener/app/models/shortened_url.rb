class ShortenedUrl < ApplicationRecord

	validates :long_url, presence: true, uniqueness: true
	validates :user_id, presence: true
	validate :no_spamming
	validate :nonpremium_max
	validate :http_prefix


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

	has_many :taggings,
		primary_key: :id,
		foreign_key: :shortened_url_id,
		class_name: :Tagging

	has_many :tag_topics,
		through: :taggings,
		source: :tag_topic

	def self.prune(n)
		to_destroy = ShortenedUrl.find_by_sql(<<-SQL)
		SELECT * FROM shortened_urls
		WHERE 
		(SELECT users.premium from users where users.id = shortened_urls.user_id ) = FALSE
		AND
		((select count(id) from visits where visits.shortened_url_id = shortened_urls.id) = 0
		OR
		(select count(id) from visits where visits.shortened_url_id = shortened_urls.id
		and visits.created_at > \'#{n.minutes.ago}\'
		) = 0) ;
		SQL
		to_destroy.each do |single|
			single.visits.destroy_all
			single.taggings.destroy_all
			single.destroy
		end
	end

	def http_prefix
		if self.long_url.include?("http://") == false && self.long_url.include?("https://") == false
			self.long_url = "http://" + self.long_url
		end
		if self.short_url == nil || self.short_url.length == 0
			self.short_url = self.class.random_code 
		end
	end

	def no_spamming
		if ShortenedUrl.all.where("user_id = ? and created_at > ? ", user_id, 1.minutes.ago).count(:id) >= 5
			errors[:user_id] << "cannot create more than 5 urls within 1 minute" 
		end
	end

	def nonpremium_max
		if self.submitter.premium == false && ShortenedUrl.all.where("user_id = ? and created_at > ?", user_id, 5.minutes.ago).count(:id) >= 5
			errors[:user_id] << "cannot create more than 5 urls within 5 minutes unless user has premium plan" 
		end
	end

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
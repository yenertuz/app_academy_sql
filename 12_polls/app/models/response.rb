class Response < ApplicationRecord

	validates :user_id, presence: true
	validates :answer_choice_id, presence: true
	validates_uniqueness_of :user_id, score: [:answer_choice_id]
	validate :not_duplicate_response
	validate :not_answering_own_poll

	belongs_to :answer_choice,
		primary_key: :id,
		foreign_key: :answer_choice_id,
		class_name: :AnswerChoice 

	belongs_to :respondent,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User

	has_one :question,
		through: :answer_choice,
		source: :question 

	def sibling_responses
		self.question.responses.where.not(id: self.id)
	end

	def respondent_has_already_answered?
		self.sibling_responses.exists?(user_id: self.user_id)
	end

	def not_duplicate_response
		errors[:base] << "User already answered this question" if respondent_has_already_answered?
	end

	def not_answering_own_poll 
		user_id = self.answer_choice.question.poll.author
		if user_id == self.user_id 
			errors[:user_id] << "User cannot answered their own question"
		end
	end

end
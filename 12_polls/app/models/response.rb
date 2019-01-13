class Response < ApplicationRecord

	validates :user_id, presence: true
	validates :answer_choice_id, presence: true
	validates_uniqueness_of :user_id, score: [:answer_choice_id]

	belongs_to :answer_choice,
		primary_key: :id,
		foreign_key: :answer_choice_id,
		class_name: :AnswerChoice 

	belongs_to :respondent,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User

end
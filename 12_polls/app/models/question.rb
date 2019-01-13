class Question < ApplicationRecord

	validates :poll_id, presence: true
	validates :text, presence: true
	validates_uniqueness_of :poll_id, scope: [:text]


	has_many :answer_choices,
		primary_key: :id,
		foreign_key: :question_id,
		class_name: :AnswerChoice 
	
	belongs_to :poll,
		primary_key: :id,
		foreign_key: :poll_id,
		class_name: :Poll

end
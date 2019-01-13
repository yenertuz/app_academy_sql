class User < ApplicationRecord

	has_many :authored_polls,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :User

	has_many :responses,
		primary_key: :id,
		foreign_key: :user_id,
		class_name: :Response

	


end
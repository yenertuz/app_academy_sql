# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Poll.delete_all
Question.delete_all 
AnswerChoice.delete_all 
Response.delete_all 


User.create(username: "yenertuz")
User.create(username: "stewie")
User.create(username: "peter")

Poll.create(user_id: User.find_by(username: "stewie").id,
			title: "Mother revenge")

Poll.create(user_id: User.find_by(username: "peter").id,
			title: "Surfing Bird")

Question.create(
	poll_id: Poll.find_by(title: "Mother revenge").id,
	text: "Have you killed your mother yet?"
)

Question.create(
	poll_id: Poll.find_by(title: "Mother revenge").id,
	text: "What type of weapon did you use or are you planning to use?"
)

Question.create(
	poll_id: Poll.find_by(title: "Surfing Bird").id,
	text: "Have you heard?"
)

Question.create(
	poll_id: Poll.find_by(title: "Surfing Bird").id,
	text: "Where can I find Jesus Christ?"
)

AnswerChoice.create(
	question_id: Question.find_by(text: "Have you killed your mother yet?").id,
	text: "Yes"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "Have you killed your mother yet?").id,
	text: "No"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "What type of weapon did you use or are you planning to use?").id,
	text: "Melee"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "What type of weapon did you use or are you planning to use?").id,
	text: "Ranged"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "Have you heard?").id,
	text: "Heard what Peter?"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "Have you heard?").id,
	text: "That the bird is the word!"
)

AnswerChoice.create(
	question_id: Question.find_by(text: "Where can I find Jesus Christ?").id,
	text: "In a random record store, of course"
)


AnswerChoice.create(
	question_id: Question.find_by(text: "Where can I find Jesus Christ?").id,
	text: "In your heart sweetheart"
)

Response.create(
	user_id: User.find_by(username: "yenertuz").id,
	answer_choice_id: AnswerChoice.all[0].id
)

Response.create(
	user_id: User.find_by(username: "yenertuz").id,
	answer_choice_id: AnswerChoice.all[2].id
)

Response.create(
	user_id: User.find_by(username: "yenertuz").id,
	answer_choice_id: AnswerChoice.all[4].id
)

Response.create(
	user_id: User.find_by(username: "yenertuz").id,
	answer_choice_id: AnswerChoice.all[7].id
)

Response.create(
	user_id: User.find_by(username: "stewie").id,
	answer_choice_id: AnswerChoice.all[0].id
)

Response.create(
	user_id: User.find_by(username: "stewie").id,
	answer_choice_id: AnswerChoice.all[3].id
)

Response.create(
	user_id: User.find_by(username: "peter").id,
	answer_choice_id: AnswerChoice.all[4].id
)

Response.create(
	user_id: User.find_by(username: "peter").id,
	answer_choice_id: AnswerChoice.all[6].id
)
class UpdateResponses < ActiveRecord::Migration[5.2]
  def change
	rename_column :responses, :question_id, :answer_choice_id
  end
end

class CreateAnswerChoices < ActiveRecord::Migration[5.2]
  def change
	create_table :answer_choices do |t|
		t.timestamps
		t.string :text, null: false
		t.integer :question_id, null: false
	end
	
	add_index :answer_choices, :question_id

  end
end

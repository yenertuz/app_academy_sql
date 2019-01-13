class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
	create_table :questions do |t|
		t.timestamps
		t.string :text
		t.integer :poll_id
	end
	
	add_index :questions, :poll_id

  end
end

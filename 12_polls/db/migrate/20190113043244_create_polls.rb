class CreatePolls < ActiveRecord::Migration[5.2]
  def change
	create_table :polls do |t|
		t.timestamps
		t.integer :user_id, null: false
		t.string :title, null: false
	end
	
	add_index :users, :username
	add_index :polls, :user_id
  end
end

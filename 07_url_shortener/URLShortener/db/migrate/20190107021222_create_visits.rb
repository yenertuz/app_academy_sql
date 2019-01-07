class CreateVisits < ActiveRecord::Migration[5.2]
  def change
	create_table :visits do |t|
		t.timestamps
		t.integer :user_id, null: false
		t.integer :shortened_url_id, null: false 
    end
  end
end

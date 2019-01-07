class CreateTagTopic < ActiveRecord::Migration[5.2]
  def change
	create_table :tag_topics do |t|
		t.timestamps
		t.string :name
    end
  end
end

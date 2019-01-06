class AddTimestampToCats < ActiveRecord::Migration[5.2]
  def change
	add_column :people, :created_at, :datetime, null: false
	add_column :people, :updated_at, :datetime, null: false
  end
end

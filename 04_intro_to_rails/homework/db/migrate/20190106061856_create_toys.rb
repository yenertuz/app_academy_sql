class CreateToys < ActiveRecord::Migration[5.2]
  def change
	create_table :toys do |t|
		t.string :address, null: false
		t.timestamps
    end
  end
end

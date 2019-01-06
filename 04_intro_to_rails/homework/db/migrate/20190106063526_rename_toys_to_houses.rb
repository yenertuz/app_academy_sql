class RenameToysToHouses < ActiveRecord::Migration[5.2]
  def change
	rename_table :toys, :houses
  end
end

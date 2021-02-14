class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|

      t.timestamps null: false
    end
  end
end

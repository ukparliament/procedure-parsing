class CreateHouseSteps < ActiveRecord::Migration
  def change
    create_table :house_steps do |t|

      t.timestamps null: false
    end
  end
end

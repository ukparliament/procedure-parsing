class CreateActualisations < ActiveRecord::Migration
  def change
    create_table :actualisations do |t|

      t.timestamps null: false
    end
  end
end

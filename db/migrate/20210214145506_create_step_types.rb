class CreateStepTypes < ActiveRecord::Migration
  def change
    create_table :step_types do |t|

      t.timestamps null: false
    end
  end
end

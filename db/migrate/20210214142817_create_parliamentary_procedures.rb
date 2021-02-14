class CreateParliamentaryProcedures < ActiveRecord::Migration
  def change
    create_table :parliamentary_procedures do |t|

      t.timestamps null: false
    end
  end
end

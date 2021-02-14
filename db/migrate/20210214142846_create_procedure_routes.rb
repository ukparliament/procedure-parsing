class CreateProcedureRoutes < ActiveRecord::Migration
  def change
    create_table :procedure_routes do |t|

      t.timestamps null: false
    end
  end
end

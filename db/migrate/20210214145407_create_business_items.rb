class CreateBusinessItems < ActiveRecord::Migration
  def change
    create_table :business_items do |t|

      t.timestamps null: false
    end
  end
end

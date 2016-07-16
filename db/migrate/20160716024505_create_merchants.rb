class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :logo

      t.timestamps null: false
    end
  end
end

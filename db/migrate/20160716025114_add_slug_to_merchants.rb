class AddSlugToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :slug, :string
    add_index :merchants, :slug, unique: true
  end
end

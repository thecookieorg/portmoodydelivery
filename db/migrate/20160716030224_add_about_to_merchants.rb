class AddAboutToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :about, :text
  end
end

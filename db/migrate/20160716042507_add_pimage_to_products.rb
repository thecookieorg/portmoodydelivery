class AddPimageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :pimage, :string
  end
end

class AddBimageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :bimage, :string
  end
end

class AddUserToMerchants < ActiveRecord::Migration
  def change
    add_reference :merchants, :user, index: true, foreign_key: true
  end
end

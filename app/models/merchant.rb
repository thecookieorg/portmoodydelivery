class Merchant < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: :slugged
	mount_uploader :logo, LogoUploader
	belongs_to :user
	has_many :products
end

class Post < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :title, use: :slugged
  	mount_uploader :bimage, BimageUploader
	belongs_to :user
end

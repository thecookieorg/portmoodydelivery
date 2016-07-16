class Product < ActiveRecord::Base
	mount_uploader :pimage, PimageUploader
end

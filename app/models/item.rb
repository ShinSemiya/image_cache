class Item < ApplicationRecord
  validates_presence_of :name, :image
  mount_uploader :image, ImageUploader

  def image_with_cache
    image_file = File.read(image.path)
    "data:#{image.content_type};base64," + Base64.strict_encode64(image_file)
  end
end

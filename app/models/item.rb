class Item < ApplicationRecord
  validates_presence_of :name, :image
  mount_uploader :image, ImageUploader

  def image_with_cache
    ItemCache::item_image_cache(cache_key, image.path, image.content_type)
  end
end

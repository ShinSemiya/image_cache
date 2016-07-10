class ItemCache
  def self.item_image_cache(cache_key, item_image_path, image_content_type)
    Rails.cache.fetch(cache_key) do
      refresh_item_image_cache(cache_key, item_image_path, image_content_type)
    end
  end

  def self.refresh_item_image_cache(cache_key, item_image_path, image_content_type)
    image_file = File.read(item_image_path)
    encoded_image_file = "data:#{image_content_type};base64," + Base64.strict_encode64(image_file)

    Rails.cache.write(cache_key, encoded_image_file, expires_in: 3.days)
    encoded_image_file
  end
end

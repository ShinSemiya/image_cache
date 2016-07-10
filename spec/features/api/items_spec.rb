require 'rails_helper'

describe 'Items', type: :request do
  include RequestHelper
  include ActionDispatch::TestProcess
  let(:test_image_file_path) { 'spec/factories/images/test.png' }

  describe 'Get #show' do
    let(:image_file_path) { 'images/test.png' }
    let(:image) { fixture_file_upload(image_file_path, 'image/png') }
    let(:item) { create(:item, image: image) }

    context 'when image is NOT cached' do
      before do
        get "/api/items/#{item.id}"
      end

      it 'return file image' do
        expect(response).to be_success
        expect(response.content_type).to eq('image/png')
        expect(response.headers["Content-Disposition"]).to eq("inline; filename=\"#{item.name}\"")
        expect(response.body).to eq(base64_image_param(item.image.path, item.image.content_type))
      end

      it 'Image is cached' do
        cached_item = Rails.cache.read(item.cache_key)
        expect(cached_item).to eq(base64_image_param(item.image.path, item.image.content_type))
      end
    end

    context 'when image is cached' do
      let(:image_for_update) { fixture_file_upload('images/test_1.png', 'image/png') }
      let(:update_params) { { image: image_for_update } }

      before do
        Rails.cache.clear
        get "/api/items/#{item.id}"
      end

      it 'update cache after read' do
        image_cache_key = item.cache_key
        expect(Rails.cache.data.keys).to eq ([image_cache_key])
        expect(response).to be_success

        base64_before_update = base64_image_param(item.image.path, item.image.content_type)

        post "/api/items/#{item.id}/update_image", update_params, post_env
        expect(response).to be_success
        expect(Rails.cache.data.keys).to eq ([image_cache_key])

        get "/api/items/#{item.id}"
        expect(response).to be_success

        cached_item = Rails.cache.read(image_cache_key)
        expect(cached_item).to eq(base64_before_update)

        updated_image_cache_key = item.reload.cache_key
        reloaded_cached_item = Rails.cache.read(updated_image_cache_key)
        expect(reloaded_cached_item).to eq(base64_image_param(item.reload.image.path, item.reload.image.content_type))
      end

      context 'when image-file is deleted' do
        it 'read from cache' do
          encoded_image = base64_image_param(item.image.path, item.image.content_type)
          item.image.remove!

          get "/api/items/#{item.id}"
          expect(response).to be_success
          expect(response.body).to eq(encoded_image) # read from cache
        end
      end
    end
  end

  describe 'Post #upload' do
    let(:item_name) { 'test_hogehoge' }
    let(:image_file_path) { 'images/test.png' }
    let(:image_file) { fixture_file_upload(image_file_path, 'image/png') }
    let(:params) { { name: item_name, image: image_file } }
    before do
      post '/api/items/upload', params, post_env
    end

    it 'Upload is successful' do
      expect(response).to be_success
      expect(Item.where(name: item_name).exists?).to be true
    end
  end

  describe 'Post #update_image' do
    let(:image_file_first)  { fixture_file_upload('images/test.png', 'image/png') }
    let(:image_file_update) { fixture_file_upload('images/test_1.png', 'image/png') }

    let(:upload_params) { { name: 'update_test', image: image_file_first } }
    let(:update_params) { { image: image_file_update } }

    before do
      post '/api/items/upload', upload_params, post_env
    end

    it 'Image is updated' do
      item = Item.last
      image_url = item.image.url

      post "/api/items/#{item.id}/update_image", update_params, post_env
      expect(response).to be_success
      expect(image_url).not_to eq item.reload.image.url
    end
  end
end

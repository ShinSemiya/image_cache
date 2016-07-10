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
end

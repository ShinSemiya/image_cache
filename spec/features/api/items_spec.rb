require 'rails_helper'

describe 'Items', type: :request do
  include ActionDispatch::TestProcess
  let(:post_env) { { 'accept' => 'application/json', 'Content-Type' => 'multipart/form-data', } }
  let(:test_image_file_path) { 'spec/factories/images/test.png' }

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

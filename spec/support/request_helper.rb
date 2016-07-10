require 'active_support/concern'

module RequestHelper
  extend ActiveSupport::Concern

  included do
    let(:post_env) {
      {
        'accept' => 'application/json',
        'Content-Type' => 'multipart/form-data',
      }
    }
  end

  private

  def base64_image_param(path, content_type)
    "data:#{content_type};base64," + Base64.strict_encode64(File.read(path))
  end
end

FactoryGirl.define do
  factory :item do
    name 'てすといめーじ'
    image { fixture_file_upload("spec/factories/images/test.png", 'image/png') }
  end
end

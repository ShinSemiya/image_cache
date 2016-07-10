source 'https://rubygems.org'


gem 'rails', '~> 5.0.0'

gem 'puma'
gem 'mysql2'

gem 'capybara'
gem 'slim-rails'

# 画像操作用
gem 'carrierwave'
gem 'rmagick'

# cache
gem 'redis'
gem "redis-rails", github: 'redis-store/redis-rails', branch: 'master'
gem 'redis-store', github: 'redis-store/redis-store', branch: 'master'

group :development do
  gem 'spring'
  gem 'listen'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem "factory_girl_rails"
end

group :development, :test do
  gem 'pry'
end

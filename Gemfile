source 'https://rubygems.org'

gem 'rails', '4.0.0'

# assets
gem 'sass-rails',   '~> 4.0.0'
gem 'haml-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'turbolinks'
gem 'jquery-rails'

# Bootstrap v3
gem 'bootstrap-sass', :git => 'git://github.com/thomas-mcdonald/bootstrap-sass.git', :branch => '3'

# Misc
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'simple_form', '>= 3.0.0.rc'
gem 'magic_encoding'
gem 'easy_captcha'
gem 'carrierwave'
gem 'mini_magick'
gem 'will_paginate'
gem 'real_settings', github: 'Macrow/real_settings'
gem 'validates_email_format_of'

# omniauth
gem 'omniauth-github'
gem 'omniauth-qq-connect'
gem 'omniauth-weibo-oauth2'

gem 'chinese_cities'
gem 'acts-as-taggable-on'
gem 'ransack', github: 'ernie/ransack'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'database_cleaner', '<= 1.0.1' # locked for sqlite3
end

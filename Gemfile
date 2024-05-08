source 'https://rubygems.org'

ruby '3.3.0'
gem 'bootstrap'
gem 'dartsass-sprockets'
gem 'rails-controller-testing'
# add font-awesome
gem 'font-awesome-rails'
# will_paginate
gem 'rb-readline'
gem 'will_paginate'
gem 'will_paginate-bootstrap4', '~> 0.2.2'

gem 'bcrypt'

gem 'faker'

gem 'rails_admin'
gem 'kaminari'

# The image_processing and mini_magick gems are both used for handling image files in Ruby.

# image_processing: This gem provides higher-level image processing helpers that are commonly needed when handling image uploads. It's built on top of mini_magick (or ruby-vips, another image processing library). The image_processing gem provides convenient methods to resize or crop images, convert image formats, and more. It's often used in combination with Active Storage, the file upload solution included with Rails.
gem 'image_processing'

# mini_magick: This gem is a Ruby wrapper for ImageMagick or GraphicsMagick command line. It allows you to manipulate images (resize, crop, draw text, etc.) using a simple and convenient Ruby interface. However, it doesn't actually include ImageMagick or GraphicsMagick, so you need to install one of those tools separately on your system.
gem 'mini_magick'

# The active_storage_validations gem is a library for adding validations to Active Storage attachments in Rails applications.
gem 'active_storage_validations'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'guard-minitest'
  gem 'minitest-reporters'
  gem 'rails-erd'
end
group :production do
  gem 'aws-sdk-s3', require: false
  gem 'pg'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

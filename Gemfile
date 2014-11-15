source 'https://rubygems.org'
ruby '1.9.3'

# bundle edge rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'
# to ping site continuously so dyno doesn't sleep
gem 'newrelic_rpm'
# critical for asset pipeline
gem 'sprockets-rails', :require => 'sprockets/railtie'

# web server
gem 'thin'
#CAS login
gem 'rubycas-client'
# use scss for stylesheets
gem 'sass-rails', '~> 4.0.3'
# use uglifier as compressor for javascript assets
gem 'uglifier', '>= 1.3.0'
# use coffeescript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]
# memcachier stuff to speed up push to heroku
gem 'dalli'
# makes following links in your web application faster
gem 'turbolinks'

group :development do
  gem 'sqlite3'
  gem 'rspec-rails'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

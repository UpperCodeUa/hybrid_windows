source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "image_processing", "~> 1.2"

gem "dartsass-rails", "~> 0.5.1"
gem "slim", "~> 5.2"
gem "devise", "~> 4.9"
gem "devise-i18n", "~> 1.13"
gem "pundit", "~> 2.5"
gem "rectify", github: "Mechetel/rectify", branch: "master"
gem "file_validators", "~> 3.0"
gem "pagy", "~> 9.3"
gem "carrierwave", "~> 3.1"
gem "validate_url", "~> 1.0"
gem "i18n", "~> 1.14"
gem "rails-i18n", "~> 8.0"
gem "telegram-bot-ruby"

gem "solid_cache"
gem "solid_cable"
gem "solid_queue"
gem "mission_control-jobs"

gem "kamal", require: false
gem "thruster", require: false

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  # gem "annotate", "~> 3.2", ">= 3.2.0"
  gem "brakeman", require: false
  gem "faker", "~> 3.2", ">= 3.2.3"
  gem "fasterer", "~> 0.11"
  gem "fuubar", "~> 2.5", ">= 2.5.1"
  gem "letter_opener_web", "~> 3.0"
  gem "pry", "~> 0.15.2"
  gem "rubocop", "~> 1.75", ">= 1.75.2", require: false
  gem "rubocop-factory_bot", "~> 2.27", ">= 2.27.1", require: false
  gem "rubocop-performance", "~> 1.25", require: false
  gem "rubocop-rails", "~> 2.31", require: false
  gem "rubocop-rspec", "~> 3.5", require: false
  gem "rubocop-capybara", "~> 2.22", ">= 2.22.1", require: false
  gem "rubocop-rspec_rails", "~> 2.31"
  gem "simplecov", require: false

  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
end

group :development do
  gem "web-console"

  gem "hotwire-spark"
  gem "ruby-lsp"
end

group :test do
  gem "capybara", "~> 3.40"
  gem "capybara-screenshot", "~> 1.0", ">= 1.0.26"
  gem "capybara_watcher", "~> 0.1.2"
  gem "database_cleaner", "~> 2.0", ">= 2.0.2"
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.3"
  gem "rack_session_access", "~> 0.2.0"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "rspec-rails", "~> 6.1", ">= 6.1.1"
  gem "shoulda-matchers", "~> 6.1"
  gem "selenium-webdriver"
end

source :rubygems

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'rack-coffee', :require => "rack/coffee"
gem 'sass'
gem 'haml'
gem 'activerecord', :require => "active_record"
gem 'sqlite3'

# Test requirements

# Padrino Stable Gem
gem 'padrino', '0.10.7'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end
gem 'hashr'

group :development, :test do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
  gem 'guard'
  gem 'spork'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'factory_girl'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  gem 'ruby_gntp'
end

require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
  require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
  FactoryGirl.find_definitions

  require 'database_cleaner'
  DatabaseCleaner.strategy = :transaction

  RSpec.configure do |conf|
    conf.include Rack::Test::Methods
    conf.include FactoryGirl::Syntax::Methods

    conf.before(:each) do
      DatabaseCleaner.start
    end

    conf.after(:each) do
      DatabaseCleaner.clean
    end

  end

  def app
    ComiketBrowser.tap { |app|  }
  end

end

Spork.each_run do

end

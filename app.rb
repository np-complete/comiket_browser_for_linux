#!/usr/bin/env ruby


require 'sinatra'
require 'haml'
require 'active_record'

require_relative 'db/helper'

get '/' do
  haml :index
end

get '/help' do
  haml :help
end

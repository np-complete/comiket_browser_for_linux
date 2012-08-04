#!/usr/bin/env ruby


require 'sinatra'
require 'haml'

get '/' do
  haml :index
end

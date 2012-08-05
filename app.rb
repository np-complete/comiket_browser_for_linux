#!/usr/bin/env ruby


require 'sinatra'
require 'haml'
require 'json'
require 'active_record'
require 'sass'

require_relative 'db/helper'

get '/' do
  haml :index
end

get '/circles' do
  content_type :json
  nums = 16
  @page = (params[:page] || 0).to_i
  @day = (params[:day] || 1).to_i
  @block = params[:block]
  @circles = Circle.limit(nums).offset(nums * @page).where(comiket_no: 82, day: @day)
  @circles = @circles.where(block: @block) if @block
  cond = {page: @page, day: @day, block: @block}.reject{|k, v| v.nil?}
  {:cond => cond, :circles => @circles}.to_json(root: nil)
end

get '/help' do
  haml :help
end

get '/application.js' do
  coffee :application
end

get '/style.css' do
  sass :style
end

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

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
  page = (params[:page] || 0).to_i
  day = (params[:day] || 1).to_i
  block = params[:block]

  offset = nums * page

  circles = Circle.where(comiket_no: 82, day: day)
  circles = circles.where(block: block) if block
  total_count = circles.count
  circles = circles.limit(nums).offset(offset)
  cond = {
    :next => (total_count < offset + nums ?
      {page: 0, day: day, block: block + 1} : {page: page + 1, day: day, block: block}).reject{|k, v| v.nil?},
    :prev => (page == 0 ?
      {page: 0, day: day, block: block} : {page: page - 1, day: day, block: block}).reject{|k, v| v.nil?}
  }
  {:cond => cond, :circles => circles}.to_json(root: nil)
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

get '/areas' do
  content_type :json
  {"E1-3" => "Ａ", "E4-6" => "シ", "W1-2" => "あ"}.to_json
end

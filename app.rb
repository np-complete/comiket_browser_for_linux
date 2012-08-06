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
  block_id = params[:block_id].try(:to_i)

  offset = nums * page

  circles = Circle.order('block_id, space_no').where(comiket_no: 82, day: day)

  circles = circles.where(block_id: block_id) if block_id
  total_count = circles.count
  circles = circles.limit(nums).offset(offset)

  cond = {
    :next => (total_count <= offset + nums ?
      {page: 0, day: day, block_id: block_id.try(:+, 1)} : {page: page + 1, day: day, block_id: block_id}).reject{|k, v| v.nil?},
    :prev => (page == 0 ?
      {page: 0, day: day, block_id: block_id.try(:-, 1)} : {page: page - 1, day: day, block_id: block_id}).reject{|k, v| v.nil?}
  }

  info = { block: Block.find(circles.first.block_id).name, day: day }
  {info: info, cond: cond, circles: circles}.to_json(root: nil)
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
  {"E1-3" => 1, "E4-6" => 38, "W1-2" => 75}.to_json
end

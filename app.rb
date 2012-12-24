#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'sinatra'
require 'haml'
require 'json'
require 'active_record'
require 'sass'

require_relative 'db/helper'

COMIKET_NUMBER = 83

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

  circles = Circle.includes([:block, :checklist]).order('block_id, space_no').where(comiket_no: COMIKET_NUMBER, day: day)

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
  {info: info, cond: cond, circles: circles}.to_json(:include => [:checklist, :block])
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

get '/blocks' do
  content_type :json
  Block.all.map{|x| [x.id, x.name]}.to_json
end

get '/colors' do
  content_type :json
  Hash[Color.all.map do |x|
      matched = x.color.match /(.{2})(.{2})(.{2})/
      color = "#{matched[3]}#{matched[2]}#{matched[1]}"
      [x.id.to_i, {color: "##{color}", title: x.title}]
    end].to_json
end

get '/checklists' do
  content_type :json
  Checklist.all.to_json(root: nil, :only => [:circle_id, :color_id, :memo])
end

put '/checklists/:id/:color_id' do
  content_type :json
  if Checklist.exists?(:circle_id => params[:id])
    checklist = Checklist.find_by_circle_id(params[:id])
    checklist.update_attributes(color_id: params[:color_id])
  else
    checklist = Checklist.create(circle_id: params[:id], color_id: params[:color_id], comiket_no: COMIKET_NUMBER)
  end
  checklist.to_json
end

delete '/checklists/:id' do
  content_type :json
  checklist = Checklist.find_by_circle_id(params[:id])
  checklist.destroy if checklist
  checklist.to_json
end

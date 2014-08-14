# -*- coding: utf-8 -*-
require_relative './comiket'
require 'csv'
class ChecklistDumper

  def self.dump
    CSV.generate do |csv|
      csv << ["Header","ComicMarketCD-ROMCatalog","ComicMarket#{Comiket::No}","UTF-8","LinCCV"]
      days = Comiket::Date
      west_block_id = Block.find_by_name('あ').id
      Color.all.each do |color|
        csv << ["Color", color.id, color.color, color.color, color.title]
      end
      Checklist.joins(:circle).where(comiket_no: Comiket::No).each do |check|
        space = case check.circle.block
                when nil
                  {page: nil, cut_index: nil, block: '×', area: '×', space_no: 'XX'}
                else
                  {
            page: check.circle.page.to_i,
            cut_index: check.circle.cut_index.to_i,
            block: check.circle.block.name,
            area: check.circle.block.id.to_i >= west_block_id ? '西' : '東',
            space_no: check.circle.space_no.to_i
          }
                end

        csv << ["Circle", check.circle.circle_id, check.color_id,
          space[:page], space[:cut_index],
          days[check.circle.day.to_i], space[:area], space[:block], space[:space_no],
          check.circle.genre_code.to_i,
          check.circle.name, check.circle.name_kana, check.circle.author, nil, nil, nil, nil,
          check.memo, nil, nil, nil, nil, nil, nil, nil, nil]
      end
      Unknown.all.each do |unknown|
        csv << ["UnKnown", unknown.name, 'a', unknown.author, unknown.memo, unknown.color_id,
          nil, nil, nil, nil, nil, nil, nil]
      end
    end
  end
end

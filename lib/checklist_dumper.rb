# -*- coding: utf-8 -*-
require 'csv'
class ChecklistDumper
  def self.dump(file)
    CSV.open(file, 'w') do |csv|
      csv << ["Header","ComicMarketCD-ROMCatalog","ComicMarket82","UTF-8","LinCCV"]
      days = %w{× 金 土 日}
      west_block_id = Block.find_by_name('あ').id
      Color.all.each do |color|
        csv << ["Color", color.id, color.color, color.color, color.title]
      end
      Checklist.joins(:circle).each do |check|
        block = case check.circle.block
                when nil
                  {block: '×', area: '×'}
                else
                  {
            block: check.circle.block.name,
            area: check.circle.block.id.to_i >= west_block_id ? '西' : '東'
          }
                end

        csv << ["Circle", check.circle_id, check.color_id, nil, nil,
          days[check.circle.day.to_i], block[:area], block[:block], check.circle.space_no, nil,
          check.circle.name, nil, check.circle.author, nil, nil, nil, nil,
          check.memo, nil, nil, nil, nil, nil, nil, nil, nil]
      end
      Unknown.all.each do |unknown|
        csv << ["UnKnown", unknown.name, nil, unknown.author, unknown.memo, unknown.color_id]
      end
    end
  end
end

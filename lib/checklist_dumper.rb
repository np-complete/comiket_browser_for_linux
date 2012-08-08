require 'csv'
class ChecklistDumper
  def self.dump(file)
    CSV.open(file, 'w') do |csv|
      csv << ["Header","ComicMarketCD-ROMCatalog","ComicMarket82","UTF-8","LinCCV"]
      Color.all.each do |color|
        csv << ["Color", color.id, color.color, color.color, color.title]
      end
      Checklist.joins(:circle).each do |check|
        csv << ["Circle", check.circle_id, check.color_id, nil, nil, nil, nil, nil, nil, nil, check.circle.name, nil, check.circle.author, nil, nil, nil, nil, check.memo, nil, nil, nil, nil, nil, nil, nil, nil]
      end
      Unknown.all.each do |unknown|
        csv << ["UnKnown", unknown.name, nil, unknown.author, unknown.memo, unknown.color_id]
    end
  end
end

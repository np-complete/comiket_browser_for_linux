require_relative './comiket'
class ChecklistParser

  attr_accessor :encode, :convert_mode
  def initialize
    @items = {:colors => [], :circles => [], :unknowns => []}
    encode = :utf8
    convert_mode = false
  end

  def parse_header(row)
    case row[3]
    when /UTF-?8/
      self.encode = :utf8
    when /S(hift)?_?JIS/
      self.encode = :sjis
    end

    self.convert_mode = true unless row[2] == "ComicMarket#{Comiket::No}"
  end

  def parse_color(row)
    if Color.exists?(row[1].to_i)
      color = Color.find(row[1].to_i)
      color.color = row[2] if row[2]
      color.title = row[4] if row[4]
      color.save
    else
      Color.create(:id => row[1].to_i, :color => row[2], :title => row[4])
    end
  end

  def parse_circle(row)
    if convert_mode
      convert_from_old_data(row[10], row[12], row[2], row[17])
    else
      Checklist.create(circle_id: row[1].to_i, color_id: row[2].to_i, memo: row[17]) unless checked_circles.include?(row[1].to_i)
    end
  end

  def parse_unknown(row)
    if convert_mode
      convert_from_old_data(row[1], row[3], row[5], row[4])
    else
      #none
    end
  end

  def checked_circles
    @checked_circles ||= Checklist.where(comiket_no: Comiket::No).map(&:circle_id)
  end

  def self.parse(csv)
    parser = ChecklistParser.new
    csv.each do |row|
      case row[0]
      when 'Circle'
        parser.parse_circle(row)
      when 'Color'
        parser.parse_color(row)
      when 'UnKnown'
        parser.parse_unknown(row)
      when 'Header'
        parser.parse_header(row)
      end
    end
    parser
  end

  private
  def convert_from_old_data(name, author, color_id, memo)
    circles = Circle.where(comiket_no: Comiket::No)
    circle = circles.where(name: name).first || circles.where(author: author).first
    if circle
      Checklist.create(circle_id: circle.id, color_id: color_id.to_i, memo: memo, comiket_no: Comiket::No)  unless checked_circles.include?(circle.id)
    else
      Unknown.create(name: name, author: author, color_id: color_id, memo: memo)
    end
  end
end

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

    self.convert_mode = true unless row[2] == 'ComicMarket82'
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
    Checklist.create(circle_id: row[1].to_i, color_id: row[2].to_i, memo: row[17]) unless checked_circles.include?(row[1].to_i)
  end

  def parse_unknown(row)
    if convert_mode
      circle = Circle.find_by_name(row[1]) || Circle.find_by_author(row[3])
      if circle
        Checklist.create(circle_id: circle.id, color_id: row[5].to_i, memo: row[4]) unless checked_circles.include?(circle.id)
      end
    end
  end

  def checked_circles
    @checked_circles ||= Checklist.all.map(&:circle_id)
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
end

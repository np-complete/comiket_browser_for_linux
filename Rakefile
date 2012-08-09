# -*- coding: utf-8 -*-
require 'rake'
require 'active_record'
require 'kconv'
require 'csv'

desc 'setup'
task :setup do
  dvd_path = ARGV.pop
  raise 'Usage: rake setup /path/to/dvd' if dvd_path == 'setup'
  circle_cuts_dir = File.expand_path('public/images/circle_cuts')
  Rake::Task['setup:create_directories'].invoke(circle_cuts_dir)
  Rake::Task['setup:copy_circle_cuts'].invoke(circle_cuts_dir, dvd_path)
  Rake::Task['db:install'].invoke(dvd_path)
end

namespace :checklist do
  require_relative 'db/helper'
  desc 'load checklist csv file'
  task :load, :filepath do |t, args|
    require_relative 'lib/checklist_parser'
    path = File.expand_path(args[:filepath])
    CSV.open(path, :encoding => NKF.guess(File.read(path))) do |csv|
      parser = ChecklistParser.parse(csv)
    end
  end

  desc 'dump checklist csv file'
  task :dump do |t, args|
    require_relative 'lib/checklist_dumper'
    ChecklistDumper.dump
  end
end

namespace :db do
  task :migrate do
    require_relative 'db/helper'
    ActiveRecord::Migrator.migrate('db/migrate/')
  end

  task :install_block, :dvd_path do |t, args|
    Rake::Task['db:migrate'].invoke
    data_file = File.expand_path('DATA82/CDATA/C82MAP.TXT', args[:dvd_path])
    CSV.open(data_file, col_sep: "\t", encoding: 'sjis') do |csv|
      blocks = csv.readlines.map{|row| row[0].toutf8 }.uniq
      blocks.each{ |block| Block.create(:name => block) }
    end
  end

  desc 'install circle info'
  task :install, :dvd_path do |t, args|
    Rake::Task['db:migrate'].invoke
    data_file = File.expand_path('DATA82/CDATA/C82ROM.TXT', args[:dvd_path])
    blocks = Block.all.map {|x| [x.name, x.id]}
    days = {'×' => 0, '金' => 1, '土' => 2, '日' => 3}
    require_relative 'db/helper'

    # Circle.delete_all
    exists_ids = Circle.all.map(&:id)
    # dirty quote_char
    CSV.foreach(data_file, col_sep: "\t", encoding: 'sjis', quote_char: '$' ) do |row|
      row.map! {|x| x.toutf8 if x.instance_of? String }
      attrs = {}
      attrs[:id]          = row[0].to_i
      if exists_ids.include?(attrs[:id])
        print 's'
      else
        block = blocks.assoc(row[5])
        attrs[:comiket_no]  = 82
        attrs[:day]         = days[row[3]]
        attrs[:block_id]    = block.id if block
        attrs[:space_no]    = row[6].try(:to_i)
        attrs[:name]        = row[8]
        attrs[:author]      = row[10]
        attrs[:book]        = row[11]
        attrs[:description] = row[14]
        Circle.create(attrs)
        print '.'
      end
    end
  end

  desc 'update circle info'
  task :update => :migrate do
    url = 'http://www.kyoshin.net/catarom/update'
  end
end

namespace :setup do
  task :create_directories, :circle_cuts_dir do |t, args|
    FileUtils.mkdir_p args[:circle_cuts_dir] unless File.exists?(args[:circle_cuts_dir])
  end

  task :copy_circle_cuts, :circle_cuts_dir, :dvd_path do |t, args|
    zip = File.expand_path('DATA82N/C082CUTH.CCZ', args[:dvd_path])
    `unzip #{zip} -d #{args[:circle_cuts_dir]}`
    FileUtils.chmod(0644, Dir.glob(File.join(args[:circle_cuts_dir], '*')))
  end

end

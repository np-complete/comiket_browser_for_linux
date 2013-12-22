# -*- coding: utf-8 -*-
require 'csv'
require 'nkf'
require_relative '../comiket'

desc 'setup'
task :setup do
  dvd_path = ARGV.pop
  raise 'Usage: rake setup /path/to/dvd' if dvd_path == 'setup'
  circle_cuts_dir = File.expand_path("public/images/circle_cuts/c#{Comiket::No}")
  Rake::Task['setup:create_directories'].invoke(circle_cuts_dir)
  Rake::Task['setup:copy_circle_cuts'].invoke(circle_cuts_dir, dvd_path)
  Rake::Task['db:install'].invoke(dvd_path)
end

namespace :checklist do
  desc 'load checklist csv file'
  task :load, :filepath do |t, args|
    require_relative '../checklist_parser'
    path = File.expand_path(args[:filepath])
    CSV.open(path, :encoding => NKF.guess(File.read(path))) do |csv|
      parser = ChecklistParser.parse(csv)
    end
  end

  desc 'dump checklist csv file'
  task :dump, :filepath do |t, args|
    require_relative '../checklist_dumper'
    path = File.expand_path(args[:filepath])
    File.open(path, 'w') do |f|
      f.puts ChecklistDumper.dump
    end
  end
end

namespace :db do
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate/')
  end

  task :install_block, :dvd_path do |t, args|
    Rake::Task['db:migrate'].invoke
    data_file = File.expand_path("DATA#{Comiket::No}/CDATA/C#{Comiket::No}MAP.TXT", args[:dvd_path])
    CSV.open(data_file, col_sep: "\t", encoding: 'sjis') do |csv|
      blocks = csv.readlines.map{|row| row[0].encode("UTF-8") }.uniq
      blocks.each{ |block| Block.create(:name => block) }
    end
  end

  desc 'install circle info'
  task :install, :dvd_path do |t, args|
    Rake::Task['db:migrate'].invoke
    data_file = File.expand_path("DATA#{Comiket::No}/CDATA/C#{Comiket::No}ROM.TXT", args[:dvd_path])
    blocks = Block.all.map {|x| [x.name, x.id]}
    days = {'×' => 0, '日' => 1, '月' => 2, '火' => 3}

    # Circle.delete_all
    Circle.transaction do
      CSV.foreach(data_file, col_sep: "\t", encoding: 'sjis', quote_char: "\t" ) do |row|
        row.map! {|x| x.encode("UTF-8") if x.instance_of? String }
        circle = Circle.find_by_circle_id_and_comiket_no(row[0].to_i, Comiket::No)
        attrs = {}
        attrs[:circle_id]          = row[0].to_i
        block = blocks.assoc(row[5])
        attrs[:comiket_no]  = Comiket::No
        attrs[:page]        = row[1]
        attrs[:cut_index]   = row[2]
        attrs[:day]         = days[row[3]]
        attrs[:block_id]    = block[1] if block
        attrs[:space_no]    = row[6].try(:to_i)
        attrs[:genre_code]  = row[7].try(:to_i)
        attrs[:name]        = row[8]
        attrs[:name_kana]   = row[9]
        attrs[:author]      = row[10]
        attrs[:book]        = row[11]
        attrs[:description] = row[14]
        if circle
          circle.update_attributes(attrs)
          print 'U'
        else
          Circle.create(attrs)
          print 'C'
        end
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
    zip = File.expand_path("DATA#{Comiket::No}N/C0#{Comiket::No}CUTH.CCZ", args[:dvd_path])
    `unzip #{zip} -d #{args[:circle_cuts_dir]}`
    FileUtils.chmod(0644, Dir.glob(File.join(args[:circle_cuts_dir], '*')))
  end

  task :copy_circle_cuts2, :dvd_path do |t, args|
    circle_cuts_dir = File.expand_path("../../../public/images/circle_cuts/c#{Comiket::No}", __FILE__)
    zip = File.expand_path("DATA#{Comiket::No}N/C0#{Comiket::No}CUTH.CCZ", args[:dvd_path])
    `unzip #{zip} -d #{circle_cuts_dir}`
    FileUtils.chmod(0644, Dir.glob(File.join(circle_cuts_dir, '*')))
  end
end

require 'rake'
require 'active_record'

desc 'setup'
task :setup do
  dvd_path = ARGV.pop
  raise 'Usage: rake setup /path/to/dvd' if dvd_path == 'setup'
  circle_cuts_dir = File.expand_path('public/images/circle_cuts')
  Rake::Task['setup:create_directories'].invoke(circle_cuts_dir)
  Rake::Task['setup:copy_circle_cuts'].invoke(circle_cuts_dir, dvd_path)
end

desc 'update circle info'
task :update do
  url = 'http://www.kyoshin.net/catarom/update'
end

namespace :setup do
  task :create_directories, :circle_cuts_dir do |t, args|
    FileUtils.mkdir_p args[:circle_cuts_dir] unless File.exists?(args[:circle_cuts_dir])
  end

  task :copy_circle_cuts, :circle_cuts_dir, :dvd_path do |t, args|
    base_dir = File.expand_path('DATA82/PDATA', args[:dvd_path])

    Dir.glob(File.join(base_dir, '/*.PNG')) do |file|
      path = File.join(args[:circle_cuts_dir], File.basename(file).downcase)
      FileUtils.copy(file, path)
      FileUtils.chmod(644, path)
    end
  end

  desc 'create database'
  task :create_database do
    require_relative 'db/helper'
    ActiveRecord::Migrator.migrate('db/migrate/')
  end
end

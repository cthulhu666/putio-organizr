# frozen_string_literal: true

require 'rake'
require 'resque/tasks'

task import: :env do
  TvShows.new.import
end

task organize: :env do
  organizer = Dependencies['organizer']
  organizer.organize_all
end

task 'resque:setup' => :env do
  Resque.logger.level = Logger::DEBUG
end

task :env do
  require_relative 'environment'
end

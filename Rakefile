# frozen_string_literal: true

require 'rake'

task import: :env do
  TvShows.new.import
end

task organize: :env do
  Organizer.new.organize
end

task :env do
  require_relative 'environment'
end

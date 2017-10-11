# frozen_string_literal: true

require 'rake'
require 'resque/tasks'

task import: :env do
  TvShows.new.import
end

task organize: :env do
  Dependencies['accounts_repository'].list_accounts.each do |a|
    Dependencies['logger'].info("Enqueue: #{a}")
    Resque.enqueue(OrganizerJob, a)
  end
end

task 'resque:setup' => :env do
  Resque.logger.level = Logger::DEBUG
end

task :env do
  require_relative 'environment'
end

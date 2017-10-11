require 'active_support/core_ext/hash/indifferent_access'

class OrganizerJob
  include Import['organizer']

  def self.queue
    :organize
  end

  def self.perform(account)
    new.organize(account)
  end

  def organize(account)
    organizer.organize(account.with_indifferent_access)
  end
end

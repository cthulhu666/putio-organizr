class OrganizerJob
  include Import['accounts_repository']
  include Import['organizer']

  def self.queue
    :organize
  end

  def self.perform(account)
    new.organize(account)
  end

  def organize(user_id)
    account = accounts_repository.find_by_user_id(user_id)
    organizer.organize(account)
  end
end

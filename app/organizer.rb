class Organizer
  include Import['putio']
  include Import['shows_repository']

  def organize
    folder = maybe_create_folder('-=- TV Series -=-')
    transfers = putio.list_completed_transfers
    transfers.each do |e|
      s = shows_repository.find_by_title(e[:transfer_name])
      next if s.nil?
      f = maybe_create_folder(s[:title], folder[:id])
      putio.move_file(e[:file_id], f[:id])
    end
  end

  def maybe_create_folder(name, parent_id = 0)
    find_folder(name, parent_id) || putio.create_folder(name, parent_id)
  end

  def find_folder(name, parent_id = 0)
    putio.list_files(parent_id).find do |e|
      e[:name] == name
    end
  end
end

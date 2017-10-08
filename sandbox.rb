require_relative 'client'
require_relative 'shows_repository'

c = PutIo::Client.new
r = ShowsRepository.new

e = c.list_events
a = c.completed_transfers(e[:events])
rs = a.map do |e|
  [e[:transfer_name], r.find_by_title(e[:transfer_name])]
end

puts rs

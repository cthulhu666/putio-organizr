require 'faraday'
require 'json'

module PutIo
  class Client
    def list_completed_transfers
      completed_transfers(list_events)
    end

    def create_folder(name, parent_id = 0)
      rs = conn.post('/v2/files/create-folder', oauth_token: 'KNN5FCFI', name: name, parent_id: parent_id)
      raise unless rs.success?
      json = JSON.parse(rs.body, symbolize_names: true)
      json[:file]
    end

    def list_events
      rs = conn.get('/v2/events/list', oauth_token: 'KNN5FCFI')
      raise unless rs.success?
      json = JSON.parse(rs.body, symbolize_names: true)
      json[:events]
    end

    def list_files(parent_id = 0)
      rs = conn.get('/v2/files/list', oauth_token: 'KNN5FCFI', parent_id: parent_id)
      raise unless rs.success?
      json = JSON.parse(rs.body, symbolize_names: true)
      json[:files]
    end

    def move_file(file_id, folder_id)
      rs = conn.post('/v2/files/move', oauth_token: 'KNN5FCFI', file_ids: file_id, parent_id: folder_id)
      raise "HTTP status #{rs.status}" unless rs.success?
      json = JSON.parse(rs.body, symbolize_names: true)
      json[:status]
    end

    def completed_transfers(events)
      events.select(&method(:transfer_completed?))
    end

    def transfer_completed?(e)
      e[:type] == 'transfer_completed'
    end

    def conn
      @conn ||= Faraday.new('https://api.put.io')
    end
  end
end

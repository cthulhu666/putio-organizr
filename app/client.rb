require 'faraday'
require 'json'

module PutIo
  class Client
    def list_events
      rs = conn.get('/v2/events/list', oauth_token: 'KNN5FCFI')
      raise unless rs.success?
      JSON.parse(rs.body, symbolize_names: true)
    end

    def list_files
      rs = conn.get('/v2/files/list', oauth_token: 'KNN5FCFI')
      raise unless rs.success?
      JSON.parse(rs.body, symbolize_names: true)
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

# frozen_string_literal: true

require 'faraday'
require 'grape'
require 'json'

class WebApp < Grape::API
  logger Logger.new(STDERR)

  params do
    requires :code
  end
  get '/oauth' do
    rs = Faraday.get 'https://api.put.io/v2/oauth2/access_token',
                     client_id: ENV.fetch('CLIENT_ID'),
                     client_secret: ENV.fetch('CLIENT_SECRET'),
                     grant_type: 'authorization_code',
                     redirect_uri: 'https://putio-organizr.herokuapp.com/oauth',
                     code: params['code']
    next 'Something went wrong' unless rs.success?
    json = JSON.parse(rs.body)
    token = json['access_token']
    puts token
    'OK'
  end
end

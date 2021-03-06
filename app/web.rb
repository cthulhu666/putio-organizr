# frozen_string_literal: true

require 'faraday'
require 'grape'
require 'json'

class WebApp < Grape::API
  logger Logger.new(STDOUT)
  format :json

  params do
    requires :code
  end
  get '/oauth' do
    token = Dependencies['putio'].fetch_access_token(params['code'])
    account = Dependencies['putio'].fetch_account_info(access_token: token)
    Dependencies['accounts_repository'].save_account(account, token)
    Resque.enqueue(OrganizerJob, account[:user_id])
    redirect '/done'
  end
end

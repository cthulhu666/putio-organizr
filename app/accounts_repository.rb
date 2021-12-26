class AccountsRepository
  include Import['db']

  def save_account(account, access_token)
    attributes = account.to_h
    db[:accounts].insert_conflict(constraint: 'accounts_user_id_key',
                                  update: { :access_token => Sequel[:excluded][:access_token] })
                 .insert(attributes.merge(access_token: access_token))
  end

  def list_accounts
    db[:accounts].all
  end

  def find_by_user_id(user_id)
    db[:accounts].first(user_id: user_id.to_s)
  end
end

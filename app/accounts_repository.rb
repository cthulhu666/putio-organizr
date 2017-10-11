class AccountsRepository
  include Import['db']

  def save_account(account, access_token)
    attributes = account.to_h
    db[:accounts].insert_conflict.insert(attributes.merge(access_token: access_token))
  end

  def list_accounts
    db[:accounts].all
  end
end

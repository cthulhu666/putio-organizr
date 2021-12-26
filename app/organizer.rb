class Organizer
  include Import['putio']
  include Import['shows_repository']
  include Import['accounts_repository']
  include Import['logger']
  include Import['redis']

  def organize_all
    accounts = Dependencies['accounts_repository'].list_accounts
    accounts.each do |account|
      organize(account)
    end
  end

  def organize(account)
    logger.info("Organize: #{account}")
    folder = maybe_create_folder('-=- TV Series -=-', access_token: account[:access_token])
    transfers = putio.list_completed_transfers(access_token: account[:access_token])

    transfers.reject(&method(:already_processed?))
             .map(&method(:find_match))
             .each do |t, m|
      if m && !ENV['DRY_RUN']
        f = maybe_create_folder(m[:title], folder[:id], access_token: account[:access_token])
        putio.move_file(t[:file_id], f[:id], access_token: account[:access_token])
        logger.debug("File moved: #{t[:transfer_name]}")
      end
      mark_as_processed!(t)
    end

  rescue PutIo::Client::UnauthorizedError => e
    logger.info("Disabling account: #{account}")
    accounts_repository.disable_account(account[:user_id])
  rescue PutIo::Client::ClientError => e
    puts e
  end

  def find_match(transfer)
    s = shows_repository.find_by_title(transfer[:transfer_name])
    if s
      logger.debug("Match found for: #{transfer[:transfer_name]} : #{s}")
    else
      logger.debug("No match for: #{transfer[:transfer_name]}")
    end
    [transfer, s]
  end

  def already_processed?(transfer)
    key = "processed-transfers-#{transfer[:user_id]}"
    redis.sismember(key, transfer[:file_id])
  end

  def mark_as_processed!(transfer)
    key = "processed-transfers-#{transfer[:user_id]}"
    redis.sadd(key, transfer[:file_id])
  end

  def maybe_create_folder(name, parent_id = 0, access_token:)
    find_folder(name, parent_id, access_token: access_token) || putio.create_folder(name, parent_id, access_token: access_token)
  end

  def find_folder(name, parent_id = 0, access_token:)
    putio.list_files(parent_id, access_token: access_token).find do |e|
      e[:name] == name
    end
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :user_id,      null: false, unique: true
      String :username,     null: false
      String :email,        null: false
      String :access_token, null: false
      Time :created_at,     null: false, default: Sequel.function('now')
    end
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:shows) do
      primary_key :id
      String :title,        null: false
      String :feed,         null: false, unique: true
      Time :created_at,     null: false, default: Sequel.function('now')
    end
  end
end

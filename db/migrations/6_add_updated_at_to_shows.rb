# frozen_string_literal: true

Sequel.migration do
  change do
    add_column :shows, :updated_at, :timestamp, null: true
  end
end

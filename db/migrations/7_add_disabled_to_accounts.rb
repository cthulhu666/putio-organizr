# frozen_string_literal: true

Sequel.migration do
  change do
    add_column :accounts, :disabled, :boolean, null: false, default: false
  end
end

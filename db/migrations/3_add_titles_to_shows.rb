# frozen_string_literal: true

Sequel.migration do
  change do
    add_column :shows, :episode_titles, 'text[]'
  end
end

# frozen_string_literal: true

Sequel.migration do
  up do
    self << <<~SQL
      create or replace view search_view as
      select id, title, setweight(to_tsvector(title), 'A') || setweight(to_tsvector(epi_title), 'B') as tsvector from
      (select id, title, unnest(episode_titles) as epi_title from shows) as s
    SQL
  end
end

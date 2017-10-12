# frozen_string_literal: true

Sequel.migration do
  up do
    self << <<~SQL
    create or replace function public.array_uniq(arr anyarray)
        returns anyarray
        language sql
    as $function$
        select array_agg(distinct a)
        from (
            select unnest(arr) a 
        ) alias
    $function$
    SQL
  end
end

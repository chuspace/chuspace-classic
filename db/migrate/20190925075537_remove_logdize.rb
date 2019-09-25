# typed: true
# frozen_string_literal: true

class RemoveLogdize < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      execute <<-SQL
        DROP FUNCTION logidze_version(bigint, jsonb, timestamp with time zone, text[]) CASCADE;
        DROP FUNCTION logidze_exclude_keys(jsonb, text[]) CASCADE;
        DROP FUNCTION logidze_compact_history(jsonb) CASCADE;
        DROP FUNCTION logidze_snapshot(jsonb, text, text[]) CASCADE;
        DROP FUNCTION logidze_logger() CASCADE;
      SQL
    end
  end
end

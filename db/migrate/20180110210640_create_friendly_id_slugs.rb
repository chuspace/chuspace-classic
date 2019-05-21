# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[6.0]
  def change
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           null: false
      t.integer  :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 50
      t.index %i[sluggable_type sluggable_id]
      t.index %i[slug sluggable_type], length: { slug: 140, sluggable_type: 50 }
      t.index %i[slug sluggable_type scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
      t.string   :scope
      t.datetime :created_at
    end
  end
end

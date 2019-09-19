# typed: false
# frozen_string_literal: true

class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.string :visit_token
      t.string :visitor_token

      # user
      t.references :user

      # standard
      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :referring_domain
      t.text :landing_page

      # technology
      t.string :browser
      t.string :os
      t.string :device_type

      # location
      t.string :country
      t.string :region
      t.string :city
      t.float :latitude
      t.float :longitude

      # utm parameters
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      # native apps
      t.string :app_version
      t.string :os_version
      t.string :platform

      t.timestamp :started_at
    end

    add_index :visits, %i[visit_token], unique: true

    create_table :events do |t|
      t.references :visit
      t.references :user

      t.string :name
      t.jsonb :properties
      t.timestamp :time
    end

    add_index :events, %i[name time]
    add_index :events, :properties, using: :gin, opclass: :jsonb_path_ops
  end
end

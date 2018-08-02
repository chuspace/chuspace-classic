# frozen_string_literal: true

class Types::RepoType < ApplicationObject
  description 'Exposes repo model fields'

  field :name, String,  'The name of the repo', null: false
  field :url, String,  'The ssh/https url of the repo', null: false
end

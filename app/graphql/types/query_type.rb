# frozen_string_literal: true

class Types::QueryType < ApplicationObject
  field :viewer, Types::Api::ViewerType, 'Current viewer', null: true

  def viewer
    Viewer::STATIC
  end
end

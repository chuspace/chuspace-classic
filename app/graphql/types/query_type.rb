# frozen_string_literal: true

class Types::QueryType < Types::Base::Object
  field :viewer, Types::Api::ViewerType, 'Current viewer', null: true

  def viewer
    Viewer::STATIC
  end
end

# frozen_string_literal: true

class Viewer < Struct.new :id
  STATIC = new(id: 'root').freeze

  def self.find(_)
    STATIC
  end
end

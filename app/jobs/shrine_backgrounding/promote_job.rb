# frozen_string_literal: true

# typed: true
class ShrineBackgrounding::PromoteJob < ApplicationJob
  queue_as :default

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end

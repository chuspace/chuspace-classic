class ShrineBackgrounding::DeleteJob < ApplicationJob
  queue_as :default

  def perform(data)
    Shrine::Attacher.delete(data)
  end
end

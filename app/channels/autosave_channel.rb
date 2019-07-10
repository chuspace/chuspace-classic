# typed: ignore
# frozen_string_literal: true

class AutosaveChannel < ApplicationCable::Channel
  def subscribed
    @blob = current_user.repository.blobs.find_by(slug: params[:slug])

    if @blob.blank?
      reject
      stop_all_streams
    else
      stream_from @blob
    end
  end

  def receive(data)
    @blob.repository.create_commit(content: data['body'], path: @blob.path, action: :update)
    ActionCable.server.broadcast(@blob, { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

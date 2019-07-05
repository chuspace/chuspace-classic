# typed: ignore
# frozen_string_literal: true

class PostChannel < ApplicationCable::Channel
  def subscribed
    @post = current_user.repository.posts.find_by(slug: params[:slug])

    if @post.blank?
      reject
      stop_all_streams
    else
      stream_from @post
    end
  end

  def receive(data)
    @post.repository.create_commit(content: data['body'], path: @post.blob_path, action: :update)
    ActionCable.server.broadcast(@post, { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

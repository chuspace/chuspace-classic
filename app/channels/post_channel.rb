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
    @post.assign_attributes(data)

    if @post.save
      @post.repository.commit(content: @post.body, path: @post.blob_path, action: :update)
      ActionCable.server.broadcast(@post, { success: true }.to_json)
    else
      ActionCable.server.broadcast(@post, { errors: @post.errors.full_messages }.to_json)
    end
  end

  def unsubscribed
    stop_all_streams
  end
end

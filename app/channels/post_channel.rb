# typed: ignore
# frozen_string_literal: true

class PostChannel < ApplicationCable::Channel
  def subscribed
    post = current_user.posts.find_by(slug: params[:id])

    if post.blank?
      reject
      stop_all_streams
    else
      stream_from "post_#{post.id}"
    end
  end

  def receive(data)
    post = current_user.posts.find_by(slug: params[:id])
    post.repository.create_commit(content: data['body'], path: post.blob_path, action: :update)
    ActionCable.server.broadcast("post_#{post.id}", { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

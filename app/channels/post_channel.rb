# typed: ignore
# frozen_string_literal: true

class PostChannel < ApplicationCable::Channel
  def subscribed
    post = current_user.posts.find_by(slug: params[:id])
    stream_from "post_#{post.id}"
  end

  def receive(data)
    post = current_user.posts.find_by(slug: params[:id])
    post.blob.save(io: data['body'], committer: current_user)
    ActionCable.server.broadcast("post_#{post.id}", { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

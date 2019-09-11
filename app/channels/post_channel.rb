# typed: ignore
# frozen_string_literal: true

class PostChannel < ApplicationCable::Channel
  def subscribed
    post = Post.find_by(slug: params[:id])
    stream_from "post_#{post.id}" if policy.allowed_to?(:edit?, post)
  end

  def receive(data)
    post = Post.find_by(slug: params[:id])

    if policy.allowed_to?(:edit?, post)
      post.blob.save(io: data['body'], committer: current_user)
      ActionCable.server.broadcast("post_#{post.id}", { success: true }.to_json)
    end
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def policy
    PostPolicy.new(user: current_user)
  end
end

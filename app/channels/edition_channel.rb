# typed: ignore
# frozen_string_literal: true

class EditionChannel < ApplicationCable::Channel
  def subscribed
    edition = current_user.editions.find(params[:id])

    if edition.blank? || edition.post.blank?
      reject
      stop_all_streams
    else
      stream_from "edition_#{edition.id}"
    end
  end

  def receive(data)
    edition = current_user.editions.find(params[:id])
    edition.repository.create_commit(content: data['body'], path: edition.post.blob_path, action: :update, branch: edition.branch_name)
    ActionCable.server.broadcast("edition_#{edition.id}", { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

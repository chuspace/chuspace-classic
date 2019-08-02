# typed: ignore
# frozen_string_literal: true

class EditionChannel < ApplicationCable::Channel
  def subscribed
    edition = current_user.contributions.find(params[:id])
    stream_from "edition_#{edition.id}"
  end

  def receive(data)
    edition = current_user.contributions.find(params[:id])
    edition.blob.save(committer: current_user, io: data['body'], branch: edition.branch_name)
    ActionCable.server.broadcast("edition_#{edition.id}", { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

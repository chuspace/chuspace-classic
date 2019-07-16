# typed: ignore
# frozen_string_literal: true

class ContributionChannel < ApplicationCable::Channel
  def subscribed
    @contribution = current_user.contributions.find(params[:id])

    if @contribution.blank? || @contribution.post.blank?
      reject
      stop_all_streams
    else
      stream_from @contribution
    end
  end

  def receive(data)
    @contribution.repository.create_commit(content: data['body'], path: @contribution.post.blob_path, action: :update, branch: @contribution.branch_name)
    ActionCable.server.broadcast(@contribution, { success: true }.to_json)
  end

  def unsubscribed
    stop_all_streams
  end
end

# typed: ignore
# frozen_string_literal: true

module Mobius
  class PostReceiveController < BaseController
    def create
      payload = params.except(:token)
      DeliveryBoy.deliver_async(payload.to_json, topic: 'repositories', partition_key: "repository_#{params[:repository_id]}}")
      self.status = 200
    end
  end
end

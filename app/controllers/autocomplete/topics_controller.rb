# typed: ignore
# frozen_string_literal: true

class Autocomplete::TopicsController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized

  def index
    @topics = Topic.where("unaccent(topics.name) ILIKE unaccent(concat('%', ?, '%'))", params[:q]).limit(5)
    render json: @topics.to_json(only: :name)
  end
end

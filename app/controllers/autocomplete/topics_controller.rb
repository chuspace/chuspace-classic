# typed: ignore
# frozen_string_literal: true

class Autocomplete::TopicsController < ApplicationController
  skip_verify_authorized

  def index
    @topics = Topic.where("unaccent(topics.name) ILIKE unaccent('%#{params[:q]}%')")
    render json: @topics.to_json(only: :name)
  end
end

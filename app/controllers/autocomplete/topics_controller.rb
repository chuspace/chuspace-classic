# frozen_string_literal: true

class Autocomplete::TopicsController < ApplicationController
  def index
    @topics = Topic.where("unaccent(topics.name) ILIKE unaccent('%#{params[:q]}%')")
    render json: @topics.to_json
  end
end

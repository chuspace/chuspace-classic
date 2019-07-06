class TopicsController < ApplicationController
  def index
    @topics = Topic.where("unaccent(topics.name) ILIKE unaccent('%#{params[:q]}%')")

    respond_to do |format|
      format.html
      format.json { render json: @topics.to_json }
    end
  end
end

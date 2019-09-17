# typed: ignore
# frozen_string_literal: true

class PublicationsController < ApplicationController
  before_action :authenticate!, except: :show
  before_action :find_publication, except: %i[index new create]
  skip_verify_authorized only: %i[index show]

  def index
    @publications = authorized_scope(Publication.listed)
  end

  def new
    @publication = Publication.new(owner: Current.user)
    authorize! @publication
  end

  def edit
    authorize! @publication
  end

  def create
    @publication = Publication.new(publication_params)
    @publication.owner = Current.user
    authorize! @publication

    if @publication.save
      redirect_to publication_path(@publication), notice: 'Publication successfully created'
    else
      render :new, turbolinks: true
    end
  end

  def show
    if @publication.personal
      redirect_to user_path(@publication.owner)
    else
      @posts = @publication.posts.published.includes(:author).limit(20).order(id: :desc)
    end
  end

  def update
    authorize! @publication

    if @publication.update(publication_params)
      flash[:notice] = "#{@publication.name} publication successfully updated"
      redirect_to publication_path(@publication)
    else
      render :edit, turbolinks: true
    end
  end

  def destroy
    authorize! @publication

    if @publication.destroy
      flash[:notice] = "#{@publication.name} publication successfully deleted"
      redirect_to root_path
    else
      redirect_to publication_path(@publication)
    end
  end

  private

  def publication_params
    params.require(:publication).permit(:name, :description, :avatar, :twitter, :website, topics: [])
  end

  def find_publication
    @publication = Publication.find_by!(slug: params[:slug])
  end
end

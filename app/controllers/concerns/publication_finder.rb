module PublicationFinder
  extend ActiveSupport::Concern

  included { before_action :find_publication }

  private

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end
end

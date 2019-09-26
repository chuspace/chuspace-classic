module PostFinder
  extend ActiveSupport::Concern

  included { before_action :find_post }

  private

  def find_post
    @post = @publication.posts.friendly.find(params[:post_slug])
  end
end

# typed: false
# frozen_string_literal: true

class Posts::SharesController < ApplicationController
  before_action :find_post
  skip_verify_authorized

  def show
    shareable = options[params[:id].to_sym]

    if shareable
      redirect_to shareable[:url] + shareable[:query].to_query
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def options
    {
      facebook: {
        url: 'https://www.facebook.com/sharer/sharer.php?',
        query: {
          u: publication_post_url(@post.publication, @post),
          t: @post.title
        }
      },

      twitter: {
        url: 'https://twitter.com/intent/tweet?',
        query: {
          url: publication_post_url(@post.publication, @post),
          text: @post.title,
          via: 'chuspace_com'
        }
      }
    }
  end

  def find_post
    @post = Post.find_by!(slug: params[:post_slug])
  end
end

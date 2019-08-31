# typed: false
# frozen_string_literal: true

class ServiceWorkerController < ApplicationController
  skip_verify_authorized
  protect_from_forgery except: :file

  def file; end

  def manifest; end
end

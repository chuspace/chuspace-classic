class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :file

  def file
  end

  def manifest
  end
end

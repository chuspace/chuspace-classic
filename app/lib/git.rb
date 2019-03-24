# frozen_string_literal: true
# Libraries
require 'ostruct'
require 'fileutils'
require 'linguist'
require 'rugged'
require "charlock_holmes"

# Gitlab::Git
require_relative 'git/config'
require_relative "git/popen"
require_relative 'git/encoding_helper'
require_relative "git/blame"
require_relative "git/blob"
require_relative "git/commit"
require_relative "git/commit_stats"
require_relative "git/compare"
require_relative "git/diff"
require_relative "git/diff_collection"
require_relative "git/repository"
require_relative "git/tree"
require_relative "git/blob_snippet"
require_relative "git/ref"
require_relative "git/branch"
require_relative "git/tag"
require_relative "git/util"
require_relative "git/attributes"

module Git
  APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../..'))
  ROOT_PATH ||= File.join(APP_ROOT, 'app/lib/git')
  SSH_ROOT ||= File.join(APP_ROOT, '.ssh')

  def self.config
    @config ||= Git::Config.new
  end
end

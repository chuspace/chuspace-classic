# frozen_string_literal: true

require_relative 'repository'
require_relative 'diff'
require 'http'
require 'yaml'
require_relative '../concerns/encoding_helper'
require_relative '../concerns/formatting_helper'

module Git
  class PreReceive
    include EncodingHelper, FormattingHelper

    attr_reader :repository, :repo_name, :repo_path, :key_id, :changes

    def initialize(repo_path, repo_name, key_id, changes)
      @repository = Git::Repository.new(path: repo_path)
      @repo_path = repo_path.strip
      @changes = changes
      @key_id = key_id
      @repo_name = repo_name
    end

    def exec
      oldrev, newrev, ref_name = changes.split(' ')

      files = `git diff-tree --name-only #{oldrev} #{newrev}`.split("\n")
      messages = []
      blobs = []

      files.each do |file|
        blob = encode!(`git show #{newrev}:#{file}`)
        next unless detect(blob)[:type] == :text

        blobs << blob
      end

      response =
        HTTP.post('http://chuspace.test/post_validations', json: { key_id: key_id, repo_name: repo_name, blobs: blobs })

      body = response.parse

      unless body['valid']
        messages << 'Validation failed...'
        messages << body['errors']
      end

      print_broadcast_message(messages.join("\n")) if messages.any?

      body['valid']
    end
  end
end

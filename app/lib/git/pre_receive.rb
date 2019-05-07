require_relative 'repository'
require_relative 'diff'
require 'http'
require 'yaml'
require_relative '../concerns/encoding_helper'

module Git
  class PreReceive
    include EncodingHelper

    attr_reader :repository, :repo_name, :repo_path, :key_id, :changes

    def initialize(repo_path, repo_name, key_id, changes)
      @repository = Git::Repository.new(path: repo_path)
      @repo_path = repo_path.strip
      @changes = changes
      @key_id = key_id
      @repo_name = repo_name
    end

    def exec
      # Get the file names, without directory, of the files that have been modified
      # between the new revision and the old revision
      $stdout.puts 'Checking marking content...'

      oldrev, newrev, ref_name = changes.split(' ')

      files = `git diff --name-only #{oldrev} #{newrev}`.split("\n")


      files.each do |file|
        content = encode!(`git show #{newrev}:#{file}`)
        response = HTTP.post('http://chuspace.test/post_validations', json: { key_id: key_id, repo_name: repo_name, markdown: content })
        body = response.parse

        $stderr.puts body.inspect
        raise StandardError, 'remote: Invalid post' unless body['valid']
      end

      $stderr.puts 'Checking failed...'

      false
      # do something here before receive
    end
  end
end

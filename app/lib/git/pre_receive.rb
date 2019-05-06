require_relative 'repository'
require_relative 'diff'
require 'http'
require_relative '../concerns/encoding_helper'

module Git
  class PreReceive
    include EncodingHelper

    attr_reader :repository, :repo_path, :key_id, :changes

    def initialize(repo_path, key_id, changes)
      @repository = Git::Repository.new(path: repo_path)
      @repo_path = repo_path.strip
      @changes = changes
      @key_id = key_id
    end

    def exec
      # Get the file names, without directory, of the files that have been modified
      # between the new revision and the old revision
      $stdout.puts 'Checking marking content...'

      oldrev, newrev, ref_name = changes.split(' ')

      files = `git diff --name-only #{oldrev} #{newrev}`.split("\n")


      files.each do |file|
        content = encode!(`git show #{newrev}:#{file}`)
        $stderr.puts content
      end

      $stderr.puts 'Checking failed...'

      false
      # do something here before receive
    end
  end
end

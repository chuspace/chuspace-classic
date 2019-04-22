# frozen_string_literal: true

module Git
  class Blob
    include EncodingHelper

    MAX_DATA_DISPLAY_SIZE = 10485760

    attr_accessor :name, :path, :size, :content, :mode, :id, :commit_sha, :binary, :author_nickname

    class << self
      def find(repository, commit_sha, name)
        rugged = repository.rugged
        commit = rugged.lookup(commit_sha)
        root_tree = commit.tree

        blob_entry = root_tree.find { |entry| entry[:name] == name }

        return nil unless blob_entry

        blob = rugged.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            content: blob.content(MAX_DATA_DISPLAY_SIZE),
            mode: blob_entry[:filemode].to_s(8),
            path: blob_entry[:name],
            commit_sha: commit_sha,
            author_nickname: repository.author_nickname,
            binary: blob.binary?
          )
        end
      end

      def all(repository, commit_sha)
        rugged = repository.rugged
        commit = rugged.lookup(commit_sha)

        commit.tree.map do |blob_entry|
          blob = rugged.lookup(blob_entry[:oid])

          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            content: blob.content(MAX_DATA_DISPLAY_SIZE),
            mode: blob_entry[:filemode].to_s(8),
            path: blob_entry[:name],
            commit_sha: commit_sha,
            author_nickname: repository.author_nickname,
            binary: blob.binary?
          )
        end
      end
    end

    def initialize(options)
      %w[id name path size content mode commit_sha author_nickname binary].each do |key|
        self.send("#{key}=", options[key.to_sym])
      end
    end

    def binary?
      @binary.nil? ? super : @binary == true
    end

    def empty?
      !content || content == ''
    end
  end
end

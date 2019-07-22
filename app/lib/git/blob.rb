# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

module Git
  class Blob
    include ::EncodingHelper
    attr_accessor :id, :binary, :name, :path, :commit_sha, :size, :content, :mode, :content_type

    class << self
      def all(repository, commit_sha = nil)
        blobs = []
        tree = commit_sha ? repository.lookup(commit_sha).tree : repository.tree

        tree.walk_blobs(:postorder) do |root, blob_entry|
          name = blob_entry[:name]
          next unless supported?(name)

          path = root.blank? ? name : File.join(root, name)
          blobs << from(repository, blob_entry, path)
        end

        blobs
      end

      def find(repository, path, commit_sha = nil)
        blobs = all(repository, commit_sha)
        blobs.find { |blob| blob.path == path }
      end

      def from(repository, blob_entry, path)
        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            path: path,
            commit_sha: repository.commit_sha,
            content_type: MimeMagic.by_path(name),
            content: blob.content,
            mode: blob_entry[:filemode].to_s(8),
            binary: blob.binary?
          )
        end
      end

      def supported?(name)
        File.extname(name) == '.md' || MimeMagic.by_path(name)&.image?
      end
    end

    def initialize(options)
      %w[id name path commit_sha size content mode binary content_type].each { |key| self.send("#{key}=", options[key.to_sym]) }
      @content = encode!(content)
    end

    def binary?
      @binary.nil? ? super : @binary == true
    end

    def io
      StringIO.new(content)
    end

    def empty?
      !content || content == ''
    end
  end
end

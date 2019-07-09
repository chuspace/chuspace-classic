# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

module Git
  class Blob
    include ::EncodingHelper
    attr_accessor :id, :binary, :name, :path, :size, :content, :mode

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

      def find(repository, oid, commit_sha = nil)
        tree = commit_sha ? repository.lookup(commit_sha).tree : repository.tree
        blob_entry = tree.find { |entry| entry[:oid] == oid }
        name = blob_entry[:name]

        if supported?(name)
          from(repository, blob_entry, File.join(name))
        end
      end

      def from(repository, blob_entry, path)
        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            path: path,
            content: encode!(blob.content),
            mode: blob_entry[:filemode].to_s(8),
            binary: blob.binary?
          )
        end
      end

      def supported?(name)
        FasterPath.extname(name) == '.md' || MimeMagic.by_path(name)&.image?
      end
    end

    def initialize(options)
      %w[id name path size content mode binary].each { |key| self.send("#{key}=", options[key.to_sym]) }
    end

    def binary?
      @binary.nil? ? super : @binary == true
    end

    def io
      StringIO.new(body)
    end

    def empty?
      !body || body == ''
    end
  end
end

# typed: ignore
# frozen_string_literal: true

module Git
  class Blob
    include ::EncodingHelper
    attr_accessor :name, :path, :size, :content, :mode, :id, :binary

    class << self
      def all(repository, commit_sha = nil)
        blobs = []
        tree = commit_sha ? repository.lookup(commit_sha).tree : repository.tree

        tree.walk_blobs(:postorder) do |root, blob_entry|
          path = root.blank? ? blob_entry[:name] : File.join(root, blob_entry[:name])
          blobs << from(repository, blob_entry, path)
        end

        blobs
      end

      def from(repository, blob_entry, path)
        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            path: path,
            content: blob.content,
            mode: blob_entry[:filemode].to_s(8),
            binary: blob.binary?
          )
        end
      end
    end

    def initialize(options)
      %w[id name path size content mode binary].each { |key| self.send("#{key}=", options[key.to_sym]) }
    end

    def binary?
      @binary.nil? ? super : @binary == true
    end

    def safe_content
      encode!(content)
    end

    def io
      StringIO.new(safe_content)
    end

    def empty?
      !content || content == ''
    end
  end
end

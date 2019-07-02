# typed: ignore
# frozen_string_literal: true

module Git
  class Blob
    include ::EncodingHelper
    attr_accessor :name, :path, :size, :content, :mode, :id, :commit_sha, :binary

    class << self
      def all(repository, commit_sha = nil)
        tree = commit_sha ? repository.lookup(commit_sha).tree : repository.head.target.tree
        from_tree(repository, tree)
      end

      def from_tree(repository, tree, blobs = [])
        tree.each do |item|
          case item[:type]
          when :blob
            blobs << from(repository, item)
          when :tree
            tree = repository.lookup(item[:oid])
            from_tree(repository, tree, blobs)
          end
        end

        blobs
      end

      def from(repository, blob_entry, tree = '')
        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            path: tree.blank? ? blob_entry[:name] : File.join(tree, blob_entry[:name]),
            content: blob.content,
            mode: blob_entry[:filemode].to_s(8),
            binary: blob.binary?
          )
        end
      end
    end

    def initialize(options)
      %w[id name path size content mode commit_sha binary].each { |key| self.send("#{key}=", options[key.to_sym]) }
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

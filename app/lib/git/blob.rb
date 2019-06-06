# frozen_string_literal: true

require_relative '../concerns/encoding_helper'

module Git
  class Blob
    include EncodingHelper
    attr_accessor :name, :path, :size, :content, :mode, :id, :commit_sha, :binary

    class << self
      def all(repository, commit_sha = nil)
        tree = commit_sha ? repository.lookup(commit_sha).tree : repository.head.target.tree

        tree.each_with_object([]) do |item, blobs|
          case item[:type]
          when :blob
            blobs << from(repository, item)
          when :tree
            tree = repository.lookup(item[:oid])
            tree.each { |entry| blobs << from(repository, entry, item[:name]) }
          end
        end
      end

      def from(repository, blob_entry, tree = '')
        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            path: File.join('/', tree, blob_entry[:name]),
            content: StringIO.new(blob.content),
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

    def empty?
      !content || content == ''
    end
  end
end

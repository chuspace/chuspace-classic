# frozen_string_literal: true

require_relative '../concerns/encoding_helper'

module Git
  class Blob
    include EncodingHelper

    MAX_DATA_DISPLAY_SIZE = 10_485_760

    attr_accessor :name, :path, :size, :content, :mode, :id, :commit_sha, :binary

    class << self
      def find(repository, id, branch = 'master')
        rugged = repository.rugged
        root_tree = repository.head.target.tree
        blob_entry = root_tree.find { |entry| entry[:oid] == id }

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
            binary: blob.binary?
          )
        end
      end

      def all(repository, branch = 'master')
        repository.head.target.tree.map do |blob_entry|
          blob = repository.lookup(blob_entry[:oid])

          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            content: blob.content(MAX_DATA_DISPLAY_SIZE),
            mode: blob_entry[:filemode].to_s(8),
            path: blob_entry[:name],
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

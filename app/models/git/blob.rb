# frozen_string_literal: true

require 'linguist'

module Git
  class Blob
    include Linguist::BlobHelper
    include EncodingHelper

    MAX_DATA_DISPLAY_SIZE = 10485760
    attr_accessor :name, :path, :size, :content, :mode, :id, :commit_id, :loaded_size, :binary

    class << self
      def find(repository, sha, path)
        commit = repository.lookup(sha)
        root_tree = commit.tree

        blob_entry = find_entry_by_path(repository, root_tree.oid, path)

        return nil unless blob_entry

        blob = repository.lookup(blob_entry[:oid])

        if blob
          Blob.new(
            id: blob.oid,
            name: blob_entry[:name],
            size: blob.size,
            content: blob.content(MAX_DATA_DISPLAY_SIZE),
            mode: blob_entry[:filemode].to_s(8),
            path: path,
            commit_id: sha,
            binary: blob.binary?
          )
        end
      end

      # Recursive search of blob id by path
      # Blob.find_entry_by_path(repo, '1a', 'something.md') # => '4a'
      def find_entry_by_path(repository, root_id, path)
        root_tree = repository.lookup(root_id)
        # Strip leading slashes
        path[/^\/*/] = ''
        path_arr = path.split('/')

        entry = root_tree.find do |entry|
          entry[:name] == path_arr[0]
        end

        return nil unless entry

        if path_arr.size > 1
          return nil unless entry[:type] == :tree
          path_arr.shift
          find_entry_by_path(repository, entry[:oid], path_arr.join('/'))
        else
          [:blob, :commit].include?(entry[:type]) ? entry : nil
        end
      end
    end

    def initialize(options)
      %w(id name path size content mode commit_id binary).each do |key|
        self.send("#{key}=", options[key.to_sym])
      end
    end

    def binary?
      @binary.nil? ? super : @binary == true
    end

    def empty?
      !content || content == ''
    end

    def content
      encode! @content
    end

    def name
      encode! @name
    end
  end
end

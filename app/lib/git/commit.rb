# typed: false
# frozen_string_literal: true

module Git
  class Commit
    include EncodingHelper
    attr_accessor :head, :refs

    attr_accessor :id,
                  :message,
                  :parent_ids,
                  :authored_date,
                  :author_nickname,
                  :author_email,
                  :created_at,
                  :committer_name,
                  :committer_email

    def initialize(raw_commit, head = nil)
      raise 'Nil as raw commit passed' unless raw_commit

      if raw_commit.is_a?(Hash)
        init_from_hash(raw_commit)
      elsif raw_commit.is_a?(Rugged::Commit)
        init_from_rugged(raw_commit)
      else
        raise "Invalid raw commit type: #{raw_commit.class}"
      end

      @head = head
    end

    def short_id(length = 10)
      id.to_s[0..length]
    end

    def safe_message
      @safe_message ||= message
    end

    def parent_id
      parent_ids.first
    end

    class << self
      def find(repo, commit_id = 'HEAD')
        return Commit.new(commit_id) if commit_id.is_a?(Rugged::Commit)

        obj = commit_id.is_a?(String) ? repo.rev_parse_target(commit_id) : Branch.dereference_object(commit_id)

        return nil unless obj.is_a?(Rugged::Commit)

        Commit.new(obj)
      rescue Rugged::ReferenceError, Rugged::InvalidError, Rugged::ObjectError
        nil
      end

      def last(repo)
        find(repo)
      end

      # Commit file in repository and return commit sha
      # options should contain next structure:
      # options = {
      #   file: {
      #     content: 'This is webpacker',
      #     path: 'welcome-to-webpacker.md'
      #   },
      #   commit: {
      #     message: 'Added a post!',
      #     branch: 'master'
      #   }
      # }

      def create(repository:, committer:, options:, action: :add)
        rugged = repository.rugged
        file = options[:file]
        commit = options[:commit]
        branch = 'master'
        parents = []
        mode = 0o100644

        author_hash = repository.author_hash.merge(time: Time.now)
        committer_hash = { name: committer.name, email: committer.email, time: Time.now }

        branch = 'refs/heads/' + branch unless branch.start_with?('refs/')

        filename = file[:path].to_s
        index = repository.index

        unless rugged.empty?
          rugged_ref = rugged.references[branch]
          raise Repository::InvalidRef.new('Invalid branch name') unless rugged_ref
          last_commit = rugged_ref.target
          index.read_tree(last_commit.tree)
          parents = [last_commit]
        end

        if action == :remove
          index.remove(filename)
        else
          file_entry = index.get(filename)

          if action == :rename
            old_path_name = file[:previous_path].to_s
            old_filename = old_path_name.to_s
            old_file_entry = index.get(old_filename)
            unless old_file_entry.blank?
              index.remove(old_filename)
            end
          end

          mode = file_entry[:mode] if file_entry && file_entry[:mode]
          content = file[:content]
          oid = rugged.write(content, :blob)
          index.add(path: filename, oid: oid, mode: mode)
        end

        opts = {}
        opts[:tree] = index.write_tree(rugged)
        opts[:author] = author_hash
        opts[:committer] = committer_hash
        opts[:message] = commit[:message]
        opts[:parents] = parents
        opts[:update_ref] = branch

        Rugged::Commit.create(rugged, opts)
      end

      def diff_from_parent(rugged_commit, options = {})
        options ||= {}
        break_rewrites = options[:break_rewrites]
        actual_options = Diff.filter_diff_options(options)

        diff =
          if rugged_commit.parents.empty?
            rugged_commit.diff(actual_options.merge(reverse: true))
          else
            rugged_commit.parents[0].diff(rugged_commit, actual_options)
          end

        diff.find_similar!(break_rewrites: break_rewrites)
        diff
      end
    end

    private

    def init_from_hash(hash)
      raw_commit = hash.symbolize_keys

      serialize_keys.each { |key| send("#{key}=", raw_commit[key]) }
    end

    def init_from_rugged(commit)
      author = commit.author
      committer = commit.committer

      @id = commit.oid
      @sha = commit.oid
      @message = encode!(commit.message)
      @authored_date = author[:time]
      @created_at = committer[:time]
      @author_nickname = encode!(author[:name])
      @author_email = encode!(author[:email])
      @committer_name = encode!(committer[:name])
      @committer_email = encode!(committer[:email])
      @parent_ids = commit.parents.map(&:oid)
    end
  end
end

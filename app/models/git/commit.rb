# frozen_string_literal: true

module Git
  class Commit
    include EncodingHelper
    attr_accessor :head, :refs

    attr_accessor :id, :message, :parent_ids, :authored_date, :author_nickname,
                  :author_email, :created_at, :committer_name, :committer_email

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

    private

    def init_from_hash(hash)
      raw_commit = hash.symbolize_keys

      serialize_keys.each do |key|
        send("#{key}=", raw_commit[key])
      end
    end

    def init_from_rugged(commit)
      author    = commit.author
      committer = commit.committer

      @id               = commit.oid
      @sha              = commit.oid
      @message          = encode!(commit.message)
      @authored_date    = author[:time]
      @created_at       = committer[:time]
      @author_nickname  = encode!(author[:name])
      @author_email     = encode!(author[:email])
      @committer_name   = encode!(committer[:name])
      @committer_email  = encode!(committer[:email])
      @parent_ids       = commit.parents.map(&:oid)
    end
  end
end

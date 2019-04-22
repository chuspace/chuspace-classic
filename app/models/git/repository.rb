# frozen_string_literal: true

module Git
  class Repository
    include Branchable

    class NoRepository < StandardError; end
    class InvalidBlobName < StandardError; end
    class InvalidRef < StandardError; end
    class InvalidAuthor < StandardError; end

    START_REF = 'HEAD'
    DEFAULT_REF = 'refs/heads/master'
    CONTRIBUTIONS_REF = 'refs/heads/contributions'

    attr_reader :author_nickname, :name, :path, :rugged, :storage_path, :namespace_path

    delegate :lookup, :checkout, :empty?, :bare?, :index, to: :rugged

    def initialize(name:)
      @name = name
      @author_nickname = name.split('/').first
      @storage_path = Git.config.git_storage_path
      @namespace_path = storage_path.join(author_nickname).tap(&:mkpath).to_s
      @path = storage_path.join(name).tap(&:mkpath).to_s
    end

    def full_path_for(name:)
      storage_path.join(name).tap(&:mkpath).to_s
    end

    def reload
      @rugged = nil
    end

    def size
      size = popen(%w[du -sk], path).first.strip.to_i
      (size.to_f / 1024).round(2)
    end

    def rugged
      @rugged ||= Rugged::Repository.new(path)
    rescue Rugged::RepositoryError, Rugged::OSError
      raise NoRepository.new('no repository for such path')
    end

    def exists?
      !!rugged
    end

    def root_branch
      @root_branch ||= discover_default_branch
    end

    def head
      rugged.head
    rescue Rugged::ReferenceError
      nil
    end

    def blobs(ref = DEFAULT_REF)
      return [] if empty?

      sha = sha_from_ref(ref)

      Blob.all(self, sha)
    end

    def find_blob_by_name(name, ref = DEFAULT_REF)
      ref ||= root_branch
      sha = sha_from_ref(ref)

      Blob.find(self, sha, name) if sha.present?
    end

    def find_blob(id, ref = DEFAULT_REF)
      ref ||= root_branch
      sha = sha_from_ref(ref)

      blob = repository.lookup(id)
      Blob.find(self, sha, blob[:name]) if sha.present?
    end

    def find_commit(sha)
      Commit.find(self, sha)
    end

    def sha_from_ref(ref)
      rev_parse_target(ref).oid
    rescue Rugged::ReferenceError
      nil
    end

    def rev_parse_target(revspec)
      obj = rugged.rev_parse(revspec)
      Branch.dereference_object(obj)
    end

    def has_commits?
      !empty?
    end

    def discover_default_branch
      names = branch_names

      return if names.empty?

      return names[0] if names.length == 1

      if head
        extracted_name = Branch.extract_branch_name(head.name)
        return extracted_name if names.include?(extracted_name)
      end

      names.include?(DEFAULT_BRANCH) ? DEFAULT_BRANCH : names[0]
    end

    def create(author:)
      repo = Rugged::Repository.init_at(path, :bare)
      repo.config['user.name'] = author.name
      repo.config['user.email'] = author.email
      repo.config['user.nickname'] = author.nickname
      repo.close
      true
    end

    def destroy
      Rails.logger.info "Removing repository for <#{name}> from <#{namespace_path}>."
      FileUtils.rm_rf(namespace_path)
      true
    end

    def rename(new_name:)
      new_path = full_path_for(name: new_name)
      Rails.logger.info "Moving repository from #{path} to <#{new_path}>."
      FileUtils.mv(path, new_path)
    end
  end
end

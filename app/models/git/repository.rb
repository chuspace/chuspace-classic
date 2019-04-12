# frozen_string_literal: true


module Git
  class Repository
    include Branchable, Commitable

    class NoRepository    < StandardError; end
    class InvalidBlobName < StandardError; end
    class InvalidRef      < StandardError; end
    class InvalidAuthor   < StandardError; end

    DEFAULT_NAME      = 'blog.git'
    START_REF         = 'HEAD'
    CONTRIBUTIONS_REF = 'refs/heads/contributions'

    attr_reader :author, :name, :full_name, :path, :rugged, :namespace_path
    delegate    :lookup, :checkout, :empty?, :bare?, :index, to: :rugged

    def initialize(author: Current.person, name: DEFAULT_NAME)
      @author = case author
                when Person
                  author
                when String
                  Person.find_by_nickname(author_nickname)
                when Integer
                  Person.find_by(id: author)
      end

      fail InvalidAuthor, 'Author not found' if @author.blank?

      @name            = name
      @full_name       = "#{@author.nickname}/#{name}"
      @namespace_path  = Git.config.git_storage_path.join(@author.nickname).tap(&:mkpath).to_s
      @path            = Git.config.git_storage_path.join(full_name).tap(&:mkpath).to_s
    end

    def reload
      @rugged = nil
    end

    def exists?
      !!rugged
    end

    def size
      size = popen(%w(du -sk), path).first.strip.to_i
      (size.to_f / 1024).round(2)
    end

    def rugged
      @rugged ||= Rugged::Repository.new(path)
    rescue Rugged::RepositoryError, Rugged::OSError
      raise NoRepository.new('no repository for such path')
    end

    def root_branch
      @root_branch ||= discover_default_branch
    end

    def blobs(branch = nil)
      return [] if empty?

      Blob.all(self)
    end

    def contributions?
      sha_from_ref(CONTRIBUTIONS_REF).present?
    end

    def head
      rugged.head
    rescue Rugged::ReferenceError
      nil
    end

    def create
      repo = Rugged::Repository.init_at(path, :bare)
      repo.close
      true
    end

    def destroy
      Rails.logger.info "Removing repository for <#{name}> from <#{namespace_path}>."
      FileUtils.rm_rf(namespace_path)
      true
    end

    def rename(new_path)
      Rails.logger.info "Moving repository from #{path} to <#{new_path}>."
      FileUtils.mv(path, new_path)
    end

    def find_file(path, ref = nil)
      ref ||= root_branch
      sha = sha_from_ref(ref)

      Blob.find(self, sha, path) if sha.present?
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
  end
end

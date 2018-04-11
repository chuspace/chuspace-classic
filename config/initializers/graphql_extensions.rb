# frozen_string_literal: true

# Accept def for preloading association
# examples:
# field :repo, -> { Types::RepoType }, 'Repo', preload: :user

GraphQL::Field.accepts_definitions(
  preload: lambda do |type, *args|
    type.metadata[:preload] ||= []
    type.metadata[:preload].concat(args)
  end,

  cache: GraphQL::Define.assign_metadata_key(:cache_proc),
  visibility: GraphQL::Define.assign_metadata_key(:visibility_proc)
)

# Accept def for adding meta data to an object which resolves to more than
# on model or class
# example:
# resolves_to_class_names ['Foo::Bar']

GraphQL::ObjectType.accepts_definitions(
  resolves_to_class_names: GraphQL::Define.assign_metadata_key(:resolves_to_class_names)
)

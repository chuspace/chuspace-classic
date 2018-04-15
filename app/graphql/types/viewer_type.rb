# frozen_string_literal: true

Types::ViewerType = GraphQL::ObjectType.define do
  name 'Viewer'
  description 'Viewer object'

  implements GraphQL::Relay::Node.interface
  global_id_field :id

  field :current_user, -> { Types::UserType }, 'Queries current logged in user fields' do
    resolve ->(_object, _args, context) { Current.user.presence }
  end

  field :new_repo, -> { Types::NewRepoType }, 'Returns data for repo form' do
    resolve ->(_object, _args, context) { RepoForm.new(Current.user.id)  }
  end
end

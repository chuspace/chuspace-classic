module Api
  module Mobius
    class Client

      class << self
        def init_bare_repo(user)
          new.call(:InitBareRepo, user: {
            id: user.id,
            nickname: user.nickname,
            repo: {
              name: user.nickname
            }
          })
        end
      end

      private

      def grpc
        Gruf::Client.new(service: Service)
      end
    end
  end
end

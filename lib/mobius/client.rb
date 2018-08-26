module Mobius
  class Client

    def init_repo(user)
      conn.post('/init_repo') do |req|
        req.body = {
          nickname: user.nickname,
          reponame: "#{user.nickname}.chuspace.com"
        }
      end
    end


    private

    def conn
      Faraday.new(url: "http://#{host}:#{port}") do |f|
        f.request :json
        f.response :json
        f.adapter :typhoeus
      end
    end

    def host
      ENV['MOBIUS_SERVICE_HOST']
    end

    def port
      ENV['MOBIUS_SERVICE_PORT']
    end
  end
end

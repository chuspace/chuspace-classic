
module Mobius
  class Auth
    BINARY = "/etc/chuspace/mobius auth"

    def self.call(key : String)
      begin
        fingerprint = Digest::MD5.hexdigest(Base64.decode_string(key)).scan(/../).map(&.[0]).join(":")

        sql = <<-STRING
          SELECT users.nickname AS nickname, key
          FROM ssh_keys
          INNER JOIN users on (ssh_keys.user_id = users.id)
          WHERE fingerprint='#{fingerprint}'
          LIMIT 1
        STRING

        nickname, key = Mobius.database.query_one sql, as: { String, String }
        command = "#{Mobius::Shell::BINARY} #{nickname}"

        sql = <<-STRING
          UPDATE ssh_keys
          SET last_used='#{Time.now}'
          WHERE fingerprint = $1
        STRING

        Mobius.database.exec sql, fingerprint.to_s
        puts "command=\"#{command}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}"
      rescue Base64::Error
        STDERR.puts "remote: <public-key> should be a valid ssh public key"
      rescue PQ::PQError
        STDERR.puts "remote: Unable to access the database"
      rescue DB::Error
        STDERR.puts "remote: Unauthorized"
      ensure
        Mobius.database.close
      end
    end
  end
end

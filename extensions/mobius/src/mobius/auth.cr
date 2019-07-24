
module Mobius
  class Auth
    BINARY = "/etc/chuspace/mobius auth"

    def self.call(key : String)
      begin
        fingerprint = Digest::MD5.hexdigest(Base64.decode_string(key)).scan(/../).map(&.[0]).join(":")

        sql = <<-STRING
          SELECT user_id, key
          FROM ssh_keys
          WHERE fingerprint= $1
          LIMIT 1
        STRING

        user_id, key = Mobius.database.query_one sql, fingerprint, as: { Int64, String }
        command = "#{Mobius::Shell::BINARY} user-#{user_id}"

        sql = <<-STRING
          UPDATE ssh_keys
          SET last_used='#{Time.now}'
          WHERE fingerprint = $1
        STRING

        Mobius.database.exec sql, fingerprint.to_s
        puts "command=\"#{command}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}"
      rescue Base64::Error
        STDERR.puts "ERROR: <public-key> should be a valid ssh public key"
      rescue PQ::PQError
        STDERR.puts "ERROR: Unable to access the database"
      rescue DB::Error
        STDERR.puts "ERROR: Unauthorized"
      ensure
        Mobius.database.close
      end
    end
  end
end

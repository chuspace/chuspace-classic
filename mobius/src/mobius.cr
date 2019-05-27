
require "db"
require "pg"
require "./mobius/auth.cr"
require "./mobius/shell.cr"

ENV["MOBIUS_ENV"] ||= "development"

module Mobius
  VERSION = "0.1.0"
  DEFAULT_DATABASE_URL = "postgres://localhost:5432/chuspace_#{ENV["MOBIUS_ENV"] }?sslmode=disable"

  def self.database
    DB.open ENV.fetch("DATABASE_URL", DEFAULT_DATABASE_URL)
  end

  def self.call(args : Array(String) = [] of String)
    case args[0]
    when "auth"
      Mobius::Auth.call(args[1])
    when "shell"
      Mobius::Shell.call(args[1])
    end
  rescue IndexError
  end
end


Mobius.call(ARGV)

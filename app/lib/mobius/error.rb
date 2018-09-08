# frozen_string_literal: false

module Mobius
  class Error < StandardError
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]

      if klass = case status
                 when 400      then Mobius::BadRequest
                 when 401      then error_for_401(headers)
                 when 403      then error_for_403(body)
                 when 404      then error_for_404(body)
                 when 405      then Mobius::MethodNotAllowed
                 when 406      then Mobius::NotAcceptable
                 when 409      then Mobius::Conflict
                 when 415      then Mobius::UnsupportedMediaType
                 when 422      then Mobius::UnprocessableEntity
                 when 451      then Mobius::UnavailableForLegalReasons
                 when 400..499 then Mobius::ClientError
                 when 500      then Mobius::InternalServerError
                 when 501      then Mobius::NotImplemented
                 when 502      then Mobius::BadGateway
                 when 503      then Mobius::ServiceUnavailable
                 when 500..599 then Mobius::ServerError
         end
        klass.new(response)
      end
    end

    def initialize(response = nil)
      @response = response
      super(build_error_message)
    end

    def self.error_for_401
      Mobius::Unauthorized
    end

    def self.error_for_403(body)
      if body =~ /rate limit exceeded/i
        Mobius::TooManyRequests
      elsif body =~ /login attempts exceeded/i
        Mobius::TooManyLoginAttempts
      elsif body =~ /abuse/i
        Mobius::AbuseDetected
      elsif body =~ /repository access blocked/i
        Mobius::RepositoryUnavailable
      elsif body =~ /email address must be verified/i
        Mobius::UnverifiedEmail
      elsif body =~ /account was suspended/i
        Mobius::AccountSuspended
      else
        Mobius::Forbidden
      end
    end

    def self.error_for_404(body)
      if body =~ /Branch not protected/i
        Mobius::BranchNotProtected
      else
        Mobius::NotFound
      end
    end

    def errors
      if data && data.is_a?(Hash)
        data[:errors] || []
      else
        []
      end
    end

    def response_status
      @response[:status]
    end

    def response_headers
      @response[:response_headers]
    end

    def response_body
      @response[:body]
    end

    private

    def data
      @data ||=
        if (body = @response[:body]) && !body.empty?
          if body.is_a?(String) &&
            @response[:response_headers] &&
            @response[:response_headers][:content_type] =~ /json/

            Sawyer::Agent.serializer.decode(body)
          else
            body
          end
        else
          nil
        end
    end

    def response_message
      case data
      when Hash
        data[:message]
      when String
        data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      summary = "\nError summary:\n"
      summary << data[:errors].map do |error|
        if error.is_a? Hash
          error.map { |k, v| "  #{k}: #{v}" }
        else
          "  #{error}"
        end
      end.join("\n")

      summary
    end

    def build_error_message
      return nil if @response.nil?

      message =  "#{@response[:method].to_s.upcase} "
      message << @response[:url].to_s + ': '
      message << "#{@response[:status]} - "
      message << "#{response_message}" unless response_message.nil?
      message << "#{response_error}" unless response_error.nil?
      message << "#{response_error_summary}" unless response_error_summary.nil?
      message
    end
  end

  class ClientError < Error; end
  class BadRequest < ClientError; end
  class Unauthorized < ClientError; end
  class Forbidden < ClientError; end
  class TooManyRequests < Forbidden; end
  class TooManyLoginAttempts < Forbidden; end
  class AbuseDetected < Forbidden; end
  class RepositoryUnavailable < Forbidden; end
  class UnverifiedEmail < Forbidden; end
  class AccountSuspended < Forbidden; end
  class NotFound < ClientError; end
  class BranchNotProtected < ClientError; end
  class MethodNotAllowed < ClientError; end
  class NotAcceptable < ClientError; end
  class Conflict < ClientError; end
  class UnsupportedMediaType < ClientError; end
  class UnprocessableEntity < ClientError; end
  class UnavailableForLegalReasons < ClientError; end
  class ServerError < Error; end
  class InternalServerError < ServerError; end
  class NotImplemented < ServerError; end
  class BadGateway < ServerError; end
  class ServiceUnavailable < ServerError; end
  class MissingContentType < ArgumentError; end
  class ApplicationCredentialsRequired < StandardError; end
  class InvalidRepository < ArgumentError; end
end

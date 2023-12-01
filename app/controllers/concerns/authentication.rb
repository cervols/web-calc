module Authentication
  include ActiveSupport::SecurityUtils

  protected

  def authenticate!
    authenticate_or_request_with_http_token do |token, _options|
      id, token = split_token(token)
      api_key = find_api_key(id)

      api_key && secure_compare_tokens(api_key.access_token, token)
    end
  end

  def split_token(token)
    token.split(':')
  end

  def find_api_key(id)
    return unless id

    ApiKey.find_by(id: id)
  end

  def secure_compare_tokens(a, b)
    return unless a && b

    secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
  end
end

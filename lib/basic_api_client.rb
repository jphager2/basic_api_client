require 'faraday'
require 'json'

class BasicApiClient
  AUTH_HEADERS = %w{ access-token token-type uid expiry client }.sort

  attr_reader :headers

  def initialize(cn, password, site, auth_url)
    @cn = cn
    @password = password
    @site = site
    @auth_url = auth_url
  end

  def conn
    @conn ||= begin
      Faraday.new(url: @site) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  def authorize
    res = conn.post do |req|
      req.url @auth_url 
      req.params['cn'] = @cn
      req.params['password'] = @password
    end

    handle_response(res)
  end

  def get(url, params = {})
    res = conn.get do |req|
      req.url url
      req.params = params.merge(req.params)
      req.headers = @headers
    end

    handle_response(res)
  end

  def post(url, params = {})
    res = conn.post do |req|
      req.url url
      req.params = params.merge(req.params)
      req.headers = @headers
    end

    handle_response(res)
  end

  private 
  def handle_response(res)
    if res.success?
      @headers = res.headers.select { |k, v| AUTH_HEADERS.include?(k) }
    else
      @headers = {}
    end
    JSON.parse(res.body) if @headers.keys.sort == AUTH_HEADERS
  end
end

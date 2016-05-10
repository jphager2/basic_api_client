require 'curb'
require 'json'

class BasicApiClient
  AUTH_HEADERS = %w{ access-token token-type uid expiry client }.sort

  attr_reader :headers
  attr_accessor :last_response, :last_return

  def initialize(cn, password, site, auth_path)
    @cn = cn
    @password = password
    @site = site
    @site.sub!(/\/+$/, '')
    @auth_url = url_for(auth_path)
  end

  def headers
    @headers ||= {}
  end

  def authorize
    @headers = {}
    params = { cn: @cn, password: @password }
    Curl.post(@auth_url, params, &method(:setup_request))
    last_return
  end

  def get(path, params = {})
    authorize unless auth_headers?

    url = url_for(path)
    Curl.get(url, params, &method(:setup_request))
    last_return
  end

  def post(path, params = {})
    authorize unless auth_headers?

    url = url_for(path)
    Curl.post(url, params, &method(:setup_request))
    last_return
  end

  private 
  def url_for(path)
    path = path.sub(/^\/+/, '')
    [@site, path].join('/')
  end

  def setup_request(req)
    req.headers = headers
    req.on_failure &method(:handle_failure)
    req.on_missing &method(:handle_failure)
    req.on_success &method(:handle_success)
  end

  def handle_success(res)
    @last_response = res
    @headers = parse_headers(res).select { |name, _| 
      AUTH_HEADERS.include?(name) }
    @last_return = JSON.parse(res.body_str)
  end

  def handle_failure(res, code)
    @last_response = res
    @headers = {}
    @last_return = nil
  end

  def parse_headers(res)
    lines = res.header_str.split("\r\n").drop(1)
    lines.each_with_object({}) { |line, headers| 
      name, value = line.split(": ")
      name.downcase!
      headers[name] = value }
  end

  def auth_headers?
    headers.keys.sort == AUTH_HEADERS
  end
end

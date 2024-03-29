require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = session_key
  end

  # def call(env)
  #   if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
  #     params = ::Rack::Utils.parse_query(env['QUERY_STRING'])
  #     
  #     unless params[@session_key].nil?
  #       env['HTTP_COOKIE'] = "#{@session_key}=#{params[@session_key]}".freeze
  #     end
  #   end
  #   
  #   @app.call(env)
  # end
  
  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      
      req = Rack::Request.new(env)
      unless req.params[@session_key].nil?
        #env['HTTP_COOKIE'] = "#{@session_key}=#{req.params[@session_key]}".freeze
        env['HTTP_COOKIE'] = [ @session_key, CGI.escape(req.params[@session_key]) ].join('=').freeze unless req.params[@session_key].nil?
      end
    end

    @app.call(env)
  end
  
end
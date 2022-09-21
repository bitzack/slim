class LogRequestsMiddleware
    def initialize(app)
        @app = app
    end
    
    def call(env)
        status, headers, response = @app.call(env)
        request = Rack::Request.new(env)
        request_body = request.body.read
        #we could check the env["HTTP_CONTENT_TYPE"] and create different handlers for those content types
        log_request_and_response!(request: request_body, headers: env["HTTP_AUTHORIZATION"], url: request.path, response: response.first)
        [status, headers, response]
    end

    def log_request_and_response!(request:, headers:, url:, response:)
        return if ['swagger', 'favicon.ico'].include?(url)
        #try to parse and catch the JSON Parser error.  rescue JSON::ParserError => e, if we just want to log the body of the message, we
        #can let the request/response columns on the "logs" table be of type "text" and not bother actually parsing the request/response
        #bodies at all.
        request = JSON.parse(request) unless request.empty?
        response = JSON.parse(response) unless response.empty?
        Log.create!(
            request: request,
            headers: headers,
            url: url,
            response: response
        )
    end
end

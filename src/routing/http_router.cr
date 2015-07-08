require "./basic_router"

module Routing
  class HttpRouter
  end
end

macro http_router(class_name)
  class {{class_name}}
    def route(request)
      process_route(request) do |res|
        return res
      end
      raise "not route for #{request.inspect}"
    end

    def process_route(request, &block)
    end

    def match_request(request, pattern, via)
      request.method == via && request.path[1..-1] == pattern
    end

    macro get(pattern, mapping)
      match(\{{pattern}}, \{{mapping}}, "GET")
    end

    macro post(pattern, mapping)
      match(\{{pattern}}, \{{mapping}}, "POST")
    end

    macro match(pattern, mapping, via)
      \{% receiver_and_message = mapping.split '#' %}
      \{% receiver = receiver_and_message[0] %}
      \{% message = receiver_and_message[1] %}
      def process_route(request)
        previous_def do |res|
          yield res
          return
        end

        if match_request(request, \{{pattern}}, \{{via}})
          yield \{{receiver.id.capitalize}}Controller.new.\{{message.id}}
        end
      end
    end

    {{yield}}
  end
end

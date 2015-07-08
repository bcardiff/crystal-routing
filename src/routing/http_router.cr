require "./basic_router"

module Routing
  class HttpRouter
  end
end

macro http_router(class_name)
  base_router {{class_name}} do
    def should_process?(request, pattern, options)
      request.method == options[:via] && request.path[1..-1] == pattern
    end

    macro route_exec(mapping)
      \{% receiver_and_message = mapping.split '#' %}
      \{% receiver = receiver_and_message[0] %}
      \{% message = receiver_and_message[1] %}
      \{{receiver.id.capitalize}}Controller.new.\{{message.id}}
    end

    macro get(pattern, mapping)
      append_route(\{{pattern}}, \{{mapping}}, {via: "GET"})
    end

    macro post(pattern, mapping)
      append_route(\{{pattern}}, \{{mapping}}, {via: "POST"})
    end

    {{yield}}
  end
end

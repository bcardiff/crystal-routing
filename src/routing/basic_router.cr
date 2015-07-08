module Routing
  class BasicRouter
  end
end

macro basic_router(class_name)
  class {{class_name}}
    def route(path)
      process_route(path) do |res|
        return res
      end
      raise "not route for #{path}"
    end

    def process_route(path, &block)
    end

    macro on(pattern, mapping)
      \{% receiver_and_message = mapping.split '#' %}
      \{% receiver = receiver_and_message[0] %}
      \{% message = receiver_and_message[1] %}
      def process_route(path)
        previous_def do |res|
          yield res
          return
        end

        if path == \{{pattern}}
          yield \{{receiver.id.capitalize}}.new.\{{message.id}}
        end
      end
    end

    {{yield}}
  end
end

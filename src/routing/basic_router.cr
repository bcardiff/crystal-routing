module Routing
  class BasicRouter
  end
end

macro basic_router(class_name)
  class {{class_name}}
    def route(path)
      raise "not route for #{path}"
    end

    macro on(pattern, mapping)
      \{% receiver_and_message = mapping.split '#' %}
      \{% receiver = receiver_and_message[0] %}
      \{% message = receiver_and_message[1] %}
      def route(path)
        if path == \{{pattern}}
          \{{receiver.id.capitalize}}.new.\{{message.id}}
        else
          previous_def
        end
      end
    end

    {{yield}}
  end
end

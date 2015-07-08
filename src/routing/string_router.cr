require "./base"

module Routing
  module StringRouter
    macro included
      include Routing::Base

      def should_process?(path, pattern, options)
        should_process_path?(path, pattern)
      end
    end

    macro route_exec(mapping)
      {% receiver_and_message = mapping.split '#' %}
      {% receiver = receiver_and_message[0] %}
      {% message = receiver_and_message[1] %}
      with_context({{receiver.id.capitalize}}.new).{{message.id}}
    end

    macro on(pattern, mapping)
      append_route({{pattern}}, {{mapping}}, nil)
    end
  end
end

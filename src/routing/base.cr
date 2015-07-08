module Routing
  module Base
    macro included
      def route(request)
        process_route(request) do |res|
          return res
        end
        raise "no route for #{request.inspect}"
      end

      def process_route(request, &block)
      end

      def should_process_path?(path, pattern)
        if pattern.empty? && path.empty?
          @last_params = {} of String => String
          return true
        end

        regex = Regex.new(pattern.gsub(/(:\w*)/, ".*"))
        return false unless path.match(regex)

        params        = {} of String => String
        path_items    = path.split("/")
        pattern_items = pattern.split("/")
        path_items.length.times do |i|
          if pattern_items[i].match(/(:\w*)/)
            params[pattern_items[i].gsub(/:/, "")] = path_items[i]
          end
        end

        @last_params = params
        return true
      end

      def with_context(receiver)
        receiver.tap do |r|
          r.routing_context = Routing::Context.new(@last_params.not_nil!)
        end
      end
    end

    macro append_route(pattern, mapping, options)
      def process_route(request)
        previous_def do |res|
          yield res
          return
        end

        if should_process?(request, {{pattern}}, {{options}})
          yield route_exec {{mapping}}
        end
      end
    end
  end
end

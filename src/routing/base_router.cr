macro base_router(class_name)
  class {{class_name}}

    def route(request)
      process_route(request) do |res|
        return res
      end
      raise "no route for #{request.inspect}"
    end

    def process_route(request, &block)
    end

    macro append_route(pattern, mapping, options)
      def process_route(request)
        previous_def do |res|
          yield res
          return
        end

        if should_process?(request, \{{pattern}}, \{{options}})
          yield route_exec \{{mapping}}
        end
      end
    end

    {{yield}}
  end
end

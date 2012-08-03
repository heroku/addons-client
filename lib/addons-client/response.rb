module Addons
  class Client
    class Response
      def initialize(response)
        @data = case response
                when String
                  response.strip.empty? ? {} : JSON.parse(response)
                when Hash
                  response
                end
        @data
      end

      def data
        @data
      end

      def to_s
        data.to_s
      end

      def to_a
        [*data]
      end

      def each(&blk)
        data.each(&blk)
      end

      def inject(hash, &blk)
        data.inject(hash,&blk)
      end

      def method_missing(name, *args, &blk)
        if @data.keys.include? name
          @data[name]
        elsif @data.keys.include? name.to_s
          @data[name.to_s]
        else
          super
        end
      end
    end
  end
end

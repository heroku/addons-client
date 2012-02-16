module Addons
  class Client
    class Response
      def initialize(response)
        @data = response.empty? ? {} : response
      end

      def to_s
        @data.to_s
      end

      def method_missing(name, *args, &blk)
        if @data.keys.include? name
          @data[name]
        else
          super
        end 
      end
    end
  end
end

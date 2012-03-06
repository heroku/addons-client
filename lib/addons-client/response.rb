module Addons
  class Client
    class Response
      def initialize(response)
        @data = if response.empty?
                  {}
                elsif response.is_a? Hash
                  response
                else
                  JSON.parse(response)
                end
        @data
      end

      def to_s
        @data.to_s
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

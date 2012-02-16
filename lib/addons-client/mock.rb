module Addons
  class Client
    module Mock
      module Methods
        def mock!
          @mock = true
        end

        def unmock!
          @mock = false
        end
       
        def mocked?
          @mock
        end
      end

      module Responses
        def mocked_provision(name)
          {
            resource_id: "DEADBEEF",
            config: {"#{name.upcase}_URL" => 'http://foo.com'},
            message: "great success",
            provider_id: 'ABC123'
          }
        end
      end
    end
  end
end

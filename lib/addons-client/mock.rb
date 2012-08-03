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
        private
        def mocked_list(search = nil)
          [{"id" => "https://addons.heroku.com/addons/cloudcounter:basic","url" => "https://addons.heroku.com/addons/cloudcounter:basic","name" => "cloudcounter:basic","description" => "The basic counter of clouds","beta" => false,"state" => "public","price_cents" => 0,"price_unit" => "month"},
           {"id" => "https://addons.heroku.com/addons/cloudcounter:pro","url" => "https://addons.heroku.com/addons/cloudcounter:pro","name" => "cloudcounter:pro","description" => "The counter of clouds for professionals","beta" => false,"state" => "public","price_cents" => 1500,"price_unit" => "month"}].
          to_json
        end

        def mocked_provision(name)
          {
            'resource_id' => "DEADBEEF",
            'config' => {"#{name.upcase}_URL" => 'http://foo.com'},
            'message' => "great success",
            'provider_id' => 'ABC123'
          }
        end

        def mocked_deprovision(resource_id)
          {}
        end

        def mocked_plan_change(resource_id, plan)
          {
            'resource_id' => resource_id,
            'config' => {"#{plan.upcase}_URL" => 'http://foo.com'},
            'message' => "great success",
            'provider_id' => 'ABC123'
          }
        end
      end
    end
  end
end

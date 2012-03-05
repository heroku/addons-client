module Addons
  class  Client
    extend Mock::Methods
    extend Mock::Responses
    DEFAULT_CONSUMER_ID = "api-client@localhost"

    def self.api_url
      set_and_validate_api_url!
      @api_url
    end

    def self.provision!(slug, opts = {})
      wrap_request do
        addon_name, plan  = slug.split(':')
        raise UserError, "No add-on name given" unless addon_name
        raise UserError, "No plan name given"   unless plan

        if mocked?
          mocked_provision(addon_name)
        else
          payload = {
            addon: addon_name,
            plan:  plan,
            consumer_id: opts[:consumer_id] || DEFAULT_CONSUMER_ID
          }
          payload.merge! :options => opts[:options] if opts[:options]
          resource.post payload, :accept => :json
        end
      end
    end

    def self.deprovision!(resource_id)
      wrap_request do
        if mocked?
          mocked_deprovision(resource_id)
        else
          resource["/#{resource_id}"].delete :accept => :json
        end
      end
    end

    def self.plan_change!(resource_id, plan)
      wrap_request do
        if mocked?
          mocked_plan_change(resource_id, addon_name)
        else
          payload = {
            plan:  plan,
          }
          resource["/#{resource_id}"].put payload, :accept => :json
        end
      end
    end

    def self.resource
      RestClient::Resource.new(api_url.to_s)
    end

    protected
    def self.wrap_request
      response = yield
      Addons::Client::Response.new(response)
    rescue RestClient::ResourceNotFound
      raise UserError, "Add-on not found: check addon spelling and plan name"
    end

    def self.set_and_validate_api_url!
      raise UserError, "ADDONS_API_URL must be set" unless ENV['ADDONS_API_URL']
      begin
        @api_url = URI.join(ENV['ADDONS_API_URL'], '/api/1/resources')
      rescue URI::InvalidURIError
        raise UserError, "ADDONS_API_URL is an invalid url"
      end
      raise UserError, "No username given" unless @api_url.user
      raise UserError, "No password given" unless @api_url.password
    end
  end
end

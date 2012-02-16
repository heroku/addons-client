module Addons
  class  Client
    DEFAULT_CONSUMER_ID = "api-client@localhost"
    extend  Mock::Methods
    include Mock::Responses

    def initialize
      set_and_validate_api_url! unless self.class.mocked?
    end

    def wrap_request
      response = yield
      Addons::Client::Response.new(response)
    rescue RestClient::ResourceNotFound
      raise UserError, "Add-on not found: check ADDONS_API_URL, addon spelling and plan name"
    end

    def provision!(slug, opts = {})
      wrap_request do 
        addon_name, plan  = slug.split(':')
        raise UserError, "No add-on name given" unless addon_name
        raise UserError, "No plan name given"   unless plan
        
        if self.class.mocked?
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

    def resource
      RestClient::Resource.new(@api_url.to_s)
    end

    protected 
    def set_and_validate_api_url!
      raise UserError, "ADDONS_API_URL must be set" unless ENV['ADDONS_API_URL']
      begin
        @api_url = URI.parse(ENV['ADDONS_API_URL'])
      rescue URL::InvalidUriError
        raise UserError, "ADDONS_API_URL is an invalid url"
      end
      raise UserError, "No username given" unless @api_url.user
      raise UserError, "No password given" unless @api_url.password
    end
  end
end

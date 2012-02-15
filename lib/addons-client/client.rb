module Addons
  class  Client
    DEFAULT_CONSUMER_ID = "api-client@localhost"

    def initialize
      set_and_validate_api_url!
    end

    def provision!(slug, opts = {})
      addon_name, plan  = slug.split(':')
      raise UserError, "No add-on name given" unless addon_name
      raise UserError, "No plan name given"   unless plan
      payload = {
        addon: addon_name,
        plan:  plan,
        consumer_id: opts[:consumer_id] || DEFAULT_CONSUMER_ID
      }
      payload.merge! :options => opts[:options] if opts[:options]
      resource.post payload, :accept => :json 
    rescue RestClient::ResourceNotFound
      raise UserError, "Add-on not found: check spelling and plan name"
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

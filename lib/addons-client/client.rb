module Addons
  class  Client
    extend Mock::Methods
    extend Mock::Responses
    DEFAULT_CONSUMER_ID = "api-client@localhost"

    def self.api_url
      @api_url = validate_api_url!
    end

    def self.list(search = nil)
      wrap_request do
        if mocked?
          mocked_list(search)
        else
          payload = { :accept => :json }
          if search.is_a? String
            payload[:params] = { :search => search } unless search == ""
          elsif !search.nil?
            payload[:params] = search
          end
          resource["/addons"].get payload
        end
      end
    end

    def self.provision!(slug, opts = {})
      validate_authenticated_api_url!
      wrap_request do
        addon_name, plan  = slug.split(':')
        raise UserError, "No add-on name given" unless addon_name

        if mocked?
          mocked_provision(addon_name)
        else
          payload = {
            :addon => addon_name,
            :consumer_id => opts[:consumer_id] || DEFAULT_CONSUMER_ID
          }
          payload.merge! :plan => plan if plan
          payload.merge! :options => opts[:options] if opts[:options]
          payload.merge! :rate => opts[:rate] if opts[:rate]
          payload.merge! :addons_id => opts[:addons_id] if opts[:addons_id]
          if start_at = opts[:start_at]
            start_at.utc
            payload.merge! :start_at => start_at.to_s
          end
          if end_at = opts[:end_at]
            end_at.utc
            payload.merge! :end_at => end_at.to_s
          end
          if config = opts[:config]
            config = config.to_json unless config.is_a? String
            payload.merge! :config => config
          end
          resource["/resources"].post payload, :accept => :json
        end
      end
    end

    def self.deprovision!(resource_id)
      validate_authenticated_api_url!
      wrap_request do
        if mocked?
          mocked_deprovision(resource_id)
        else
          resource["/resources/#{resource_id}"].delete :accept => :json
        end
      end
    end

    def self.plan_change!(resource_id, plan)
      validate_authenticated_api_url!
      wrap_request do
        if mocked?
          mocked_plan_change(resource_id, plan)
        else
          payload = {
            :plan => plan,
          }
          resource["/resources/#{resource_id}"].put payload, :accept => :json
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

    def self.validate_authenticated_api_url!
      raise UserError, "No username given" unless api_url.user
      raise UserError, "No password given" unless api_url.password
    end

    def self.validate_api_url!
      api_url = nil
      raise UserError, "ADDONS_API_URL must be set" unless ENV['ADDONS_API_URL']
      begin
        api_url = URI.join(ENV['ADDONS_API_URL'], '/api/1')
      rescue URI::InvalidURIError
        raise UserError, "ADDONS_API_URL is an invalid url"
      end
      api_url
    end
  end
end

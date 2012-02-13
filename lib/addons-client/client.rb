class Addons::Client
  attr_accessor :scheme

  def initialize(opts = {})
    validate_new_options! opts
    @username = opts[:username]
    pre_token = [opts[:salt], opts[:password]].join(':')
    @password = Digest::SHA1.hexdigest(pre_token)
    @consumer_id = opts.fetch :consumer_id, 'api-client@localhost'
    @scheme   = opts.fetch(:scheme, 'https')
  end

  def validate_new_options!(opts)
    raise UserError, "No username given" unless opts[:username]
    raise UserError, "No salt given"     unless opts[:salt]
    raise UserError, "No password given" unless opts[:password]
  end

  def provision!(slug, opts = {})
    addon_name, plan  = slug.split(':')
    raise UserError, "No add-on name given" unless addon_name
    raise UserError, "No plan name given"   unless plan
    payload = {
      addon: addon_name,
      plan:  plan,
      consumer_id: opts.fetch(:consumer_id, "api-client@localhost")
    }
    payload.merge! :options => opts[:options] if opts[:options]
    resource.post payload
  end

  def resource
    addons_api_url = "#{@scheme}://#{@username}:#{@password}@localhost:3000"
    RestClient::Resource.new(addons_api_url)['/api/1/resources']
  end
end

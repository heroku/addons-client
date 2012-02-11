class Addons::Client
  def initialize(opts = {})
    @username = opts[:username]
    pre_token = [opts[:salt], opts[:password]].join(':')
    @password = Digest::SHA1.hexdigest(pre_token)
    @consumer_id = opts.fetch :consumer_id, 'api-client@localhost'
  end

  def provision!(slug, opts = {})
    addon_name, plan  = slug.split(':')
    raise UserError, "No add-on name given" unless addon_name
    raise UserError, "No plan name given"   unless plan
    resource.post({
      addon: addon_name,
      plan:  plan,
      consumer_id: opts.fetch(:consumer_id, "api-client@localhost")
    })
  end

  protected
  def resource
    addons_api_url = "http://#{@username}:#{@password}@localhost:3000"
    RestClient::Resource.new(addons_api_url)['/api/1/resources']
  end
end

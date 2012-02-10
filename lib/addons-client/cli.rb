module Addons::Client::CLI
  def self.run!
    define_settings
    load_settings!
  end

  def self.run_command!

  end

  def self.define_settings
    Settings.define :api_salt, 
      :env_var => "ADDONS_API_SALT", 
      :description => "Salt used for hashing login",
      :required => true
    Settings.define :api_password, 
      :env_var => "ADDONS_API_PASSWORD", 
      :description => "Addons API password", 
      :required => true
  end

  def self.load_settings!
    Settings.use :commandline
    Settings.resolve!
  rescue RuntimeError => e
    raise Addons::UserError.new(e)
  end
end

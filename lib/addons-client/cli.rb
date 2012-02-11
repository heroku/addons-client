module Addons::CLI
  extend self

  def run!
    define_settings
    load_settings!
    run_command!
  end

  def run_command!
    command = Settings.rest.first
    case command 
    when /provision/i
      slug = Settings.rest[1]
      raise UserError, "Must supply add-on:plan as second argument" unless slug
      client.provision!(slug)
    else
      if command
        puts "#{command} is not a valid command"
      else
        puts "Command must be one of: provision, deprovision, planchange"
      end
    end
  end

  def client
    @client ||= Addons::Client.new(:username => 'heroku', 
                                   :salt     => Settings[:api_salt], 
                                   :password => Settings[:api_password])
  end

  def define_settings
    load File.expand_path('../settings.rb', __FILE__)
  end

  def load_settings!
    Settings.use :commandline
    Settings.resolve!
  rescue RuntimeError => e
    raise Addons::UserError.new(e)
  end
end

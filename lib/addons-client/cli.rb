require 'pp'
module Addons::CLI
  extend self

  def run!
    load_settings!
    run_command!
  end

  def run_command!
    command = Settings.rest.first
    case command 
    when /provision/i
      slug = Settings.rest[1]
      raise UserError, "Must supply add-on:plan as second argument" unless slug
      response = client.provision!(slug, :options => Settings[:options], 
                                         :consumer_id => Settings[:consumer_id])
      puts "Provisioned #{slug}"
      pp response
    else
      if command
        puts "#{command} is not a valid command"
      else
        puts "Command must be one of: provision, deprovision, planchange"
      end
    end
  end

  def client
    @client ||= Addons::Client.new
  end

  def load_settings!
    Settings.use :commandline
    Settings.resolve!
  rescue RuntimeError => e
    raise Addons::UserError.new(e)
  end
end

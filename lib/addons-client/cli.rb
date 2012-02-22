module Addons::CLI
  extend self

  def run!
    load_settings!
    run_command!
  end

  def run_command!
    command = Settings.rest.first
    case command
    when /deprovision/i
      resource_id = Settings.rest[1]
      response = client.deprovision!(resource_id)
      puts "Deprovisioned #{resource_id}"
      puts response
    when /provision/i
      slug = Settings.rest[1]
      raise UserError, "Must supply add-on:plan as second argument" unless slug
      response = client.provision!(slug, :options => Settings[:options],
                                         :consumer_id => Settings[:consumer_id])
      puts "Provisioned #{slug}"
      puts response
    when /plan-change/i
      resource_id = Settings.rest[1]
      slug = Settings.rest[2]
      raise UserError, "Must supply add-on:plan as second argument" unless slug
      response = client.plan_change!(resource_id, slug,
        :options => Settings[:options], :consumer_id => Settings[:consumer_id])
      puts "Plan Changed to #{slug}"
      puts response
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

  def puts(string)
    STDOUT.puts(string)
  end

  def load_settings!
    Settings.use :commandline
    Settings.resolve!
  rescue RuntimeError => e
    raise Addons::UserError.new(e)
  end
end

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
      raise Addons::UserError, "Must supply resource id" unless resource_id
      response = client.deprovision!(resource_id)
      puts "Deprovisioned #{resource_id}"
      puts response
    when /provision/i
      slug = Settings.rest[1]
      raise Addons::UserError, "Must supply add-on:plan" unless slug
      response = client.provision!(slug, :options => Settings[:options],
                                         :consumer_id => Settings[:consumer_id])
      puts "Provisioned #{slug}"
      puts response
    when /plan-change/i
      resource_id = Settings.rest[1]
      raise Addons::UserError, "Must supply resource id" unless resource_id
      plan = Settings.rest[2]
      raise Addons::UserError, "Must supply plan after resource id" unless plan
      response = client.plan_change!(resource_id, plan)
      puts "Plan Changed to #{plan}"
      puts response
    else
      if command
        puts "#{command} is not a valid command"
      else
        puts "Command must be one of: provision, deprovision, plan-change"
      end
    end
  end

  def client
    @client ||= Addons::Client
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

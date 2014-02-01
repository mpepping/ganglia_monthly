#!/usr/bin/env ruby 

# 20121010, Martijn Pepping <martijn@xbsd.nl>
#
# Script to fetch performance graphs from Ganglia monitoring. 
# Usable for monthly reporting or such.

require 'yaml'
require 'date'
require 'net/http'

# Config and options are set in this yaml file.
config_yaml = 'ganglia_monthly.yaml'


# Fetch a jpg for each URL in the config file.
config = YAML.load_file(config_yaml)
month_epoch = Date.strptime(config['reportmonth'], "%Y%m").strftime('%s')

config['urls'].each do |name, url|
  url_full = config['reporturl'] + "?" + url + "&st=" + month_epoch
  jpg_name = config['outputdir'] + '/' + name + ".jpg"

  puts "Fetching: http://" + config['reporthost'] + url_full
  puts "Saved to: #{jpg_name}"
  puts ""

  Net::HTTP.start(config['reporthost']) do |http|
    resp = http.get(url_full)
    open(jpg_name, 'wb') { |file|
      file.write(resp.body)
    }
  end

end


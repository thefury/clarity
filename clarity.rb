#!/usr/bin/env ruby

require 'optparse'

# Sites to block

SITES=[
  'facebook.com',
  'www.facebook.com',
  'reddit.com',
  'www.reddit.com',
  'news.ycombinator.com',
]

# Parse usage options
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: clarity.rb [options]'

  opts.on('-c', '--clear', 'Remove blocks from the hosts file') do |c|
    options[:clear] = c
  end

  opts.on('-h', '--help', 'Print this help') do |h|
    puts opts
    exit
  end
end.parse!


class Clarity
  HOSTS="/etc/hosts"

  attr_accessor :hosts_file

  def initialize
    @hosts_file=HOSTS
  end

  def block_sites(sites=SITES)
    File.open(@hosts_file, 'a') do |f|
      sites.each { |site| f.puts "127.0.0.1 #{site} # CLARITY" }
    end
  end

  def clear_blocks
    content = File.readlines(@hosts_file).reject { |line| line =~ /# CLARITY/ }
    File.open(@hosts_file, 'w') { |f| content.each { |line| f.puts line } }
  end
end

# Main script

clarity = Clarity.new

if options[:clear]
  clarity.clear_blocks
else
  clarity.block_sites
end

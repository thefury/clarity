#!/usr/bin/env ruby

require 'optparse'

HOSTS="/etc/hosts"
SITES=[
  'facebook.com',
  'www.facebook.com',
  'reddit.com',
  'www.reddit.com',
  'news.ycombinator.com',
]
COMMENT='# CLARITY'

# TODO read more sites from a dotfile

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: clarity.rb [options]'

  opts.on('-c', '--clear', 'Remove blocks from the hosts file') do |c|
    options[:clear] = c
  end

  opts.on('-v', '--verbose', 'Verbose output') do |v|
    options[:verbose] = v
  end

  opts.on('-h', '--help', 'Print this help') do |h|
    puts opts
    exit
  end
end.parse!


def block_sites
  File.open(HOSTS, 'a') do |f|
    SITES.each { |site| f.puts "127.0.0.1 #{site} #{COMMENT}" }
  end
end

def clear_blocks
  content = File.readlines(HOSTS).reject { |line| line =~ /#{COMMENT}/ }
    File.open(HOSTS, 'w') { |f| content.each { |line| f.puts line } }
end

if options[:clear]
  clear_blocks
  puts 'cleared site blockages' if options[:verbose]
else
  block_sites
  puts 'blocked sites' if options[:verbose]
end

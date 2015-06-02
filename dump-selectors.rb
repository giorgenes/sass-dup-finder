#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'haml'
require 'sass'
require 'ap'

def node_to_set(node)
	s = Set.new
	node.children.each do |n|
		s.add("#{n.name}: #{n.value}") if n.respond_to?(:name)
	end

	s
end

def print_node(node)
	node.children.each do |n|
		puts "#{n.name}: #{n.value}" if n.respond_to?(:name)
	end
end

files = {}
rules = {}
ARGV.each do |f|
	engine = Sass::Engine.new(File.new(f).read, :syntax => :scss)
	engine.to_tree.children.each do |c|
		if c.is_a?(Sass::Tree::RuleNode)
			#ap c.rule
			c.rule.each do |rule|
				rule.split(",").each do |r|
					puts r
				end
			end
		end
	end
end

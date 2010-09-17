#!/usr/bin/ruby

require 'rubygems'
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
	files[f] = Set.new
	rules[f] = {}
	engine = Sass::Engine.new(File.new(f).read, :syntax => :scss)
	engine.to_tree.children.each do |c|
		if c.is_a?(Sass::Tree::RuleNode)
			#ap c.rule
			c.rule.each do |rule|
				rule.tr(' ', '').split(",").each do |r|
					files[f].add(r)
					rules[f][r] = c
					#puts r
				end
			end
		end
	end
end


files.keys.combination(2) do |fl|
	k = fl[0]
	k2 = fl[1]
	v = files[k]
	v2 = files[k2]
	i = v.intersection(v2)
	unless i.empty? or k == k2
		puts "#{k} with #{k2}"
		puts "equal selectors"
		ap i
		i.each do |r|
			a = node_to_set(rules[k][r])
			b = node_to_set(rules[k2][r])
			diff = (a + b) - (a & b)
			puts "different rules for #{r}"
			diff.each do |dd|
				puts "    #{dd}"
			end
		end
	end
end

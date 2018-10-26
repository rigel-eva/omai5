# frozen_string_literal: true

require 'octokit'
require 'nokogiri'
require 'base64'
require "#{Dir.pwd}/lib/omai5/helper_functions.rb"
require "#{Dir.pwd}/lib/omai5/base_class.rb"
require "#{Dir.pwd}/lib/omai5/helper_functions.rb"
require "#{Dir.pwd}/lib/omai5/base_class.rb"
require "#{Dir.pwd}/lib/omai5/character_base.rb"
require "#{Dir.pwd}/lib/omai5/skill.rb"
require "#{Dir.pwd}/lib/omai5/contact.rb"
character = Nokogiri::XML(File.read('/Volumes/Data Swap/Tabletop RPGs/Character Sheets/Runnerhub/Babsí/Babsí.chum5'))
# Reading Skills
boop = Omai5::Skill.from_base_node(character)
boop.each do |skill|
  puts skill unless skill.defaulting?
end
Omai5::SkillGroup.skill_group_list(version: boop[0].version).each do |skill_group|
  print "#{skill_group}: "
  if Omai5::SkillGroup.broken?(skill_group, boop)
    puts 'Broken'
  else
    puts 'Intact'
  end
end
puts 'Done Chummer!'
contacts = Omai5::Contact.from_base_node(character)
contacts.each do |contact|
  puts contact
end

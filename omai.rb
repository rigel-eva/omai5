#!/usr/bin/env ruby -w
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
require "#{Dir.pwd}/lib/omai5/gear.rb"
require "#{Dir.pwd}/lib/omai5/character.rb"
# character = Nokogiri::XML(File.read('/Volumes/Data Swap/Tabletop RPGs/Character Sheets/Runnerhub/Babsí/Babsí.chum5'))
character = Omai5::Character.from_file('/Volumes/Data Swap/Tabletop RPGs/Character Sheets/Runnerhub/Babsí/Babsí.chum5')
# Reading Skills
puts '============Skills============'
# boop = Omai5::Skill.from_base_node(character)
character.skills.each do |skill|
  puts skill unless skill.defaulting?
end
puts '============Skill Groups============'
Omai5::SkillGroup.skill_group_list(version: character.skills[0].version).each do |skill_group|
  print "#{skill_group}: "
  if Omai5::SkillGroup.broken?(skill_group, character.skills)
    puts 'Broken'
  else
    puts 'Intact'
  end
end
puts '============Contacts============'
character.contacts.each do |contact|
  puts contact
  puts "\t#{contact.notes}"
end
puts '============Gear============'
character.gear.each do |gear|
  puts gear
end
# Ok one last thing I wanna do
puts character.r20_roll_skill("Assensing")
puts 'Done Chummer!'

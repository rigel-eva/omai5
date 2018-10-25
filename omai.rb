# frozen_string_literal: true

require 'octokit'
require 'nokogiri'
require 'base64'

character = Nokogiri::XML(File.read('/Volumes/Data Swap/Tabletop RPGs/Character Sheets/Runnerhub/Babsí/Babsí.chum5'))
character_app_version = character.xpath('.//createdversion/text()').to_s
skills = Nokogiri::XML(Base64.decode64(Octokit.contents('chummer5a/chummer5a',
                                                        path: 'Chummer/data/skills.xml', ref: character_app_version).content))
# Reading Skills
character.xpath('//skill').each do |skill|
  skill_id = skill.xpath('.//suid/text()')
  puts skill.class
  # puts skill_id
  skill_listing = skills.xpath("//id[text()=\"#{skill_id}\"]")
  skill_name = skill_listing.xpath('.//../name/text()').to_s
  skill_name = skill.xpath('.//name/text()').to_s if skill_listing.empty?
  skill_specialization = skill.xpath('.//spec/name/text()').to_s
  skill_name += " [#{skill_specialization}]" unless skill_specialization.empty?
  skill_ranks = skill.xpath('.//karma/text()').to_s.to_i + skill.xpath('.//base/text()').to_s.to_i
  puts "#{skill_name}: #{skill_ranks}" unless skill_ranks == 0
end
# boop=skills.xpath("//id[text()=\"48763fa5-4b89-48c7-80ff-d0a2761de4c0\"]")
# puts boop.xpath(".//../name/text()")
puts 'Done Chummer!'

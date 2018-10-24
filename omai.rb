# frozen_string_literal: true

require 'octokit'
require 'nokogiri'
require 'base64'
actions = Nokogiri::XML(Base64.decode64(Octokit.contents('chummer5a/chummer5a', path: 'Chummer/data/skills.xml', ref: "5.202.0").content))

boop=actions.xpath("//id[text()=\"48763fa5-4b89-48c7-80ff-d0a2761de4c0\"]")
puts boop.xpath(".//../name/text()")
puts 'Done Chummer!'
asdf
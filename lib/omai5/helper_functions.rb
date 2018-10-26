# frozen_string_literal: true

require 'octokit'
require 'nokogiri'
require 'base64'
##
# A Handy module for reading 5th editon Chummer Sheets
module Omai5
  ##
  # @!attribute [r] sheets
  # The Reference Sheets that the module has downloaded from the Chummer Github
  def self.sheets
    @@sheets
  end

  ##
  # Helper Method to download sheets and save them in a class variable in the Module for later
  # @param [String] sheet_name Name of the sheet we need to download
  # @options options [String] version Version of the sheet we need downloaded
  # @return[Nokogiri::XML::NodeSet] The Sheet we just downloaded
  def self.download_sheet(sheet_name, options = { version: nil })
    @@sheets ||= {}
    @@sheets[sheet_name] ||= {}
    @@sheets[sheet_name][options[:version]] ||= Nokogiri::XML(Base64.decode64(Octokit.contents('chummer5a/chummer5a', path: "Chummer/data/#{sheet_name}.xml", ref: @version).content))
    @@sheets[sheet_name][options[:version]]
  end
end
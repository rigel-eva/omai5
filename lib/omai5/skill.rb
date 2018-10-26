# frozen_string_literal: true

##
# A Handy module for reading 5th editon Chummer Sheets
module Omai5
    ##
  # This Class defines a skill for a character
  class Skill < OmaiBase
    attr_reader :id, :knowledge
    attr_accessor :base, :karma, :specialization, :version
    ##
    # Initializes our skill
    # @param [String] id The UID of the skill
    # @param [Fixnum] base The Base Value of the skill
    # @param [Fixnum] karma The Karma Value of the skill
    # @option options [String] ('') version: The version of Chummer the original file was built with
    # @option options [String] ('') specialization: Skill Specialization
    # @option options [String] ('') name: The skill name
    # @option options [Boolean] (false) knowledge: If the skill is a knowledge skill
    # @option options [String] catagory The Skill Catagory of the skill
    # @return [Omai5::Skill]
    def initialize(id, base, karma,
                   options = {
                     version: nil,
                     specialization: '',
                     name: '',
                     knowledge: false,
                     catagory: '',
                     notes: ''
                   })
      @id = id
      @base = base
      @karma = karma
      @version = options[:version]
      @specialization = options[:specialization]
      @name = options[:name]
      @knowledge = options[:knowledge]
      @catagory = options[:catagory]
      super options
    end

    ##
    # @!attribute [r] name
    def name # :nodoc:
      get_skill_listing_and_fill if @name == ''
      @name
    end

    ##
    # @!attribute [r] ability
    def ability # :nodoc:
      get_skill_listing_and_fill if @ability.nil?
      @ability
    end

    ##
    # @!attribute [r] skill_group
    def skill_group # :nodoc:
      get_skill_listing_and_fill if @skill_group.nil?
      @skill_group
    end

    ##
    # @!attribute [r] catagory
    def catagory
      get_skill_listing_and_fill if @catagory.nil?
      @catagory
    end

    ##
    # Returns true if the character would default on a check using this skill
    # @return [Boolean] If the skill is defaulting
    def defaulting?
      (@karma + @base).zero? && catagory != 'Language'
    end

    ##
    # Returns true if the skill is defaultable
    # @return [Boolean] If the skill is defaultable
    def defaultable?
      sheet = Omai5.download_sheet('skills', version: version)
      sheet.xpath("//id[text()=\"#{@id}\"/../default/text()").to_s == 'True'
    end

    ##
    # Does what every other single other to_s does. No need to roke this.
    # @return [String]
    def to_s
      to_string
    end

    ##
    # Like to_s but with Debug options
    # @return [String]
    def to_string(options = { debug: false })
      # Using this as a way to double check if we need to grab our skill listing
      get_skill_listing_and_fill if @ability.nil?
      returner = "(#{@id}) #{name} " if options[:debug]
      returner ||= "#{@name} "
      returner += "[#{@specialization}] " unless @specialization == ''
      if @catagory == 'Language' && (@karma + @base).zero?
        return returner + 'N'
      else
        return returner + "#{@ability} + #{@karma + @base}"
      end
    end
    class << self
      ##
      # Builds a skill from a Nokogiri Node set
      # @param [Nokogiri::XML::NodeSet] node_set Node set from which we are going to build the skill
      # @option options [String] ('') version: The version of Chummer the original file was built with
      # @return [Omai5:Skill]
      def from_skill_node(node_set, options = { version: nil })
        skill_id = node_set.xpath('.//suid/text()').to_s
        skill_name = node_set.xpath('child::name/text()').to_s
        skill_catagory = node_set.xpath('.//skillcategory/text()').to_s
        skill_knowledge = node_set.xpath('.//isknowledge/text()').to_s == 'True'
        skill_karma = node_set.xpath('.//karma/text()').to_s.to_i
        skill_base = node_set.xpath('.//base/text()').to_s.to_i
        skill_specialization = node_set.xpath('.//spec/name/text()').to_s
        version = options[:version]
        Omai5::Skill.new(skill_id, skill_base, skill_karma,
                         version: version,
                         specialization: skill_specialization,
                         name: skill_name,
                         knowledge: skill_knowledge,
                         catagory: skill_catagory)
      end

      ##
      # Builds a list of skills from a Nokogiri Node set
      # @param [Nokogiri::XML::NodeSet] node_set Node set from which we are going to build the list of skills
      # @option options [String] ('') version: The version of Chummer the original file was built with
      # @return [Omai5:Skill]
      def from_base_node(node_set, options = { version: nil })
        skills = []
        version = options[:version]
        version = node_set.xpath('//appversion/text()').to_s if version.nil?
        node_set.xpath('//skill').each do |skill|
          skills.push(from_skill_node(skill, version: version))
        end
        skills
      end
    end

    private

    ##
    # Our quick and dirty function for telling the module to fetch the sheet, and setting a few accessors to appropriate skills
    # @return [nil]
    def get_skill_listing_and_fill
      Omai5.download_sheet('skills', version: @version)
      skill_listing = Omai5.sheets['skills'][@version].xpath("//id[text()=\"#{@id}\"]").xpath('.//..')
      @name = skill_listing.xpath('.//name/text()').to_s if @name == ''
      @ability = skill_listing.xpath('.//attribute/text()').to_s
      @skill_group = skill_listing.xpath('.//skillgroup/text()').to_s
      @catagory = skill_listing.xpath('.//category/text()').to_s if @catagory == ''
      nil
    end
  end

  ##
  # This class defines a skill group for a character
  class SkillGroup
    ##
    # Initializes our skill group
    # @param [String] name of the skill group
    # @param [Fixnum] base The Base Value of the skill
    # @param [Fixnum] karma The Karma Value of the skill
    # @param [Hash] options the options to create a skill with.
    # @option options [String] ('') version: The version of Chummer the original file was built with
    def initialize(name, base, karma, options = { version: nil })
      @name = name
      @base = base
      @karma = karma
      @version = options[:version]
    end

    ##
    # Gets the applicable skills to the skill group and returns them as a listing
    # @return [Array] Array of the skills in the skill group
    def get_skills
      Omai5.download_sheet('skills', version: @version)
      # Grabbing All skills within our skillgroup
      skill_ids = Omai5.sheets['skills'][@version].xpath("//skillgroup[text()=\"#{@name}\"]").xpath('.//../id/text()')
      skills = []
      skill_id.each do |id|
        skills.push Omai5::Skill.new(id.to_s, @base, @karma, version: version)
      end
    end
    class << self
      ##
      # Checks if a skill group is broken
      # @param [String] skill_group
      # @param [Array<Omai5:Skill>] skill_array - An array of the skills our character has to check
      # @return [Boolean] If the skill group is broken
      def broken?(skill_group, skill_array)
        # Downloading the sheet using the first version of the skills we are seeing
        skill_listing = Omai5.download_sheet('skills') # , version: skill_array[0].version)
        skills_id_in_group = skill_listing.xpath("//skillgroup[text()=\"#{skill_group}\"]/../id/text()").map(&:to_s)
        karmaValue = nil
        baseValue = nil
        skill_array.each do |skill|
          if skills_id_in_group.include? skill.id
            if karmaValue.nil? && baseValue.nil?
              karmaValue = skill.karma
              baseValue = skill.base
            elsif karmaValue != skill.karma || baseValue != skill.base
              return true
            end
          end
        end
        false
      end

      ##
      # Gives a list of the available skill groups
      # @option options [String] ('') version: The version of Chummer the original file was built with
      # @return [Array<String>] A listing of Skill Groups in Array form
      def skill_group_list(options = { version: nil })
        version = options[:version]
        puts version
        skill_listing = Omai5.download_sheet('skills', version: version)
        skill_listing.xpath('//skillgroups/name/text()').map(&:to_s)
      end
    end
  end
end
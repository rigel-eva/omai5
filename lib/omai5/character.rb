# frozen_string_literal: true

module Omai5
  #
  # Your Runner, in all of it's Glory
  #
  class Attribute
    attr_accessor :base, :karma, :metatype_min, :metatype_max
    def initialize(base, karma, metatype_min, metatype_max)
      @base = base
      @karma = karma
      @metatype_min = metatype_min
      @metatype_max = metatype_max
    end

    def total
      @base + @karma + @metatype_min
    end

    def to_i
      total
    end

    def to_s
      to_i.to_s
    end
  end
  class Character < CharacterBase
    attr_accessor :skills, :contacts, :gear
    def initialize(attributes, options = { contacts: [],
                                           skills: [],
                                           gear: [],
                                           name: '',
                                           nickname: '',
                                           metatype: '',
                                           age: '',
                                           sex: '',
                                           notes: '' })
      @attributes = attributes
      @skill_hash = {}
      # Ok, making my life about 100% easier here for the r20 roll skill function
      options[:skills].each{|skill|
        @skill_hash[skill.name]=skill
      }
      @contacts = options[:contacts]
      @gear = options[:gear]
      super(options)
    end
    def skills
      puts @skill_hash.values.class
      @skill_hash.values
    end
    #
    # Generates a string that Rolls the specified skill in roll20 
    #
    # @param [String] skill_name Name of the skill we are rolling
    #
    # @return [String] The Roll20 Roll string to send
    #
    def r20_roll_skill (skill_name)
      skill = @skill_hash[skill_name]
      puts skill.ability
      puts skill.id
      skill.r20_roll_string(@attributes[skill.ability].to_i)
    end
    class << self
      def from_file(file_location)
        from_string(File.read(file_location))
      end

      def from_string(string)
        from_nokogiri(Nokogiri::XML(string))
      end

      def from_nokogiri(nokogiri_node)
        skills = Skill.from_base_node(nokogiri_node)
        contacts = Contact.from_base_node(nokogiri_node)
        gear = Gear.from_base_node(nokogiri_node)
        attributes = {}
        nokogiri_node.xpath('//attributes/attribute').each do |attribute|
          attribute_name = attribute.xpath('./name/text()').to_s
          attribute_karma = attribute.xpath('./karma/text()').to_s.to_i
          attribute_base = attribute.xpath('./base/text()').to_s.to_i
          attribute_min = attribute.xpath('./metatypemin/text()').to_s.to_i
          attribute_max = attribute.xpath('./metatypemax/text()').to_s.to_i
          attributes[attribute_name] = Attribute.new(attribute_base, attribute_karma, attribute_min, attribute_max)
          puts attributes[attribute_name]
        end
        Character.new(attributes, contacts: contacts, skills: skills, gear: gear)
      end
    end
  end
end

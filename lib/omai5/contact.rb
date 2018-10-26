# frozen_string_literal: true

module Omai5
  ##
  # This Class stores contacts that a deniable asset mgiht need
  class Contact < CharacterBase
    # @!attribute connection
    #   @return [Fixnum] Power of the connections the Contact has
    attr_accessor :connection
    # @!attribute loyalty
    #   @return [Fixnum] Ammount of Loyalty the Contact has
    attr_accessor :loyalty
    # @!attribute preferred_payment
    #   @return [String] The Contact's Prefered Payment
    attr_accessor :preferred_payment
    # @!attribute hobbies_vice
    #   @return [String] What the Contact enjoies doing
    attr_accessor :hobbies_vice
    # @!attribute personal_life
    #   @return [String] More along of who is the contact surrounding themselves with
    attr_accessor :personal_life
    # @!attribute type
    #   @return [String] What kind of services can you get out of the contact
    attr_accessor :type
    # @!attribute location
    #   @return [String] Where is the contact
    attr_accessor :location
    # @!attribute group_name
    #   @return [String] Name of the group the contact is associated with
    attr_accessor :group_name
    # @!attribute group
    #   @return [String] Is the contact someone you know through a group?
    attr_accessor :group
    # @!attribute family
    #   @return [String] Is the contact someone whom you share family ties with?
    attr_accessor :family
    # @!attribute blackmail
    #   @return [String] Is the contact someone whom you've blackmaled?
    attr_accessor :blackmail

    #
    # Initializes the Contact
    #
    # @param [Fixnum] loyalty Ammount of Loyalty the Contact has
    # @param [Fixnum] connection Power of the connections the Contact has
    # @option [String] name Name of the contact
    # @option [String] metatype Metatype of the contact
    # @option [String] age Age of the Contact
    # @option [String] preferred_payment The Contact's Prefered Payment
    # @option [String] hobbies_vice What the Contact enjoies doing
    # @option [String] personal_life More along of who is the contact surrounding themselves with
    # @option [String] type What kind of services can you get out of the contact
    # @option [String] location Where is the contact
    # @option [Boolean] group Is the contact someone you know through a group?
    # @option [Boolean] family Is the contact someone whom you share family ties with?
    # @option [Boolean] blackmail Is the contact someone whom you've blackmaled?
    # @option [String] notes Notes on the contact
    #
    def initialize(loyalty, connection, options = { name: '',
                                                    metatype: '',
                                                    age: '',
                                                    sex: '',
                                                    preferred_payment: '',
                                                    hobbies_vice: '',
                                                    personal_life: '',
                                                    type: '',
                                                    location: '',
                                                    group: false,
                                                    group_name: '',
                                                    family: false,
                                                    blackmail: false,
                                                    notes: '' })
      @connection = connection
      @loyalty = loyalty
      @preferred_payment = options[:preferred_payment]
      @hobbies_vice = options[:hobbies_vice]
      @personal_life = options[:personal_life]
      @type = options[:type]
      @group = options[:group]
      @family = options[:family]
      @blackmail = options[:blackmail]
      @location = options[:location]
      @group_name = options[:group_name]
      @type = type
      super options
    end

    #
    # Does what it says on the tin. Exactly what it says on the tin. this returns a string.
    #
    # @return [String] A stringed up version of your contact. Just be gentle
    #
    def to_s
      returner = "#{@name} - C: #{@connection} L: #{@loyalty} "
      returner += '[Blackmail] ' if @blackmail
      returner += '[Family] ' if @family
      returner += '[Group] ' if @group
      returner
    end
    class << self
      #
      # Generates a contact from a nokogiri node
      #
      # @param [Nokogiri::XML::NodeSet] node_set Node set we are generating the contact from
      # @option options [String] ('') version: The version of Chummer the original file was built with
      # 
      #
      # @return [Omai5::Contact] Contact 
      #
      def from_contact_node(node_set, options = { version: nil })
        name = node_set.xpath('.//name/text()').to_s
        role = node_set.xpath('.//role/text()').to_s
        location = node_set.xpath('.//location/text()').to_s
        connection = node_set.xpath('.//connection/text()').to_s.to_i
        loyalty = node_set.xpath('.//loyalty/text()').to_s.to_i
        metatype = node_set.xpath('.//metatype/text()').to_s
        sex = node_set.xpath('.//sex/text()').to_s
        age = node_set.xpath('.//age/text()').to_s
        type = node_set.xpath('.//contacttype/text()').to_s
        group_name = node_set.xpath('.//group_name/text()').to_s
        hobby_vice = node_set.xpath('.//hobbyvice/text()').to_s
        personal_life = node_set.xpath('.//personallife/text()').to_s
        preferred_payment = node_set.xpath('.//preferredpayment').to_s
        blackmail = node_set.xpath('.//blackmail/text()').to_s == 'True'
        group = node_set.xpath('.//group/text()').to_s == 'True'
        family = node_set.xpath('.//family/text()').to_s == 'True'
        notes = node_set.xpath('.//notes/text()').to_s
        version=options[:version]
        Omai5::Contact.new(loyalty, connection,
                           name: name,
                           metatype: metatype,
                           age: age,
                           sex: sex,
                           preferred_payment: preferred_payment,
                           hobbies_vice: hobby_vice,
                           personal_life: personal_life,
                           type: type,
                           location: location,
                           group_name: group_name,
                           group: group,
                           family: family,
                           blackmail: blackmail,
                           version: version,
                           notes: notes)
      end

      #
      # Builds a list of contacts from a nokogiri nodeset
      #
      # @param [<Type>] node_set Nokogiri Node set we are building all of our contacts from (Should be either contacts node or just the entire .chum5 file)
      # @option options [String] ('') version: The version of Chummer the original file was built with
      #
      # @return [Array<Omai5::Contact>] Compiled Contact list
      #
      def from_base_node(node_set, options = { version: nil })
        contacts = []
        version = options[:version]
        version = node_set.xpath('//appversion/text()').to_s if version.nil?
        node_set.xpath('//contact').each do |contact|
          contacts.push(from_contact_node(contact, version: version))
        end
        contacts
      end
    end
  end
end

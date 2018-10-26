# frozen_string_literal: true

module Omai5
  ##
  # A Basic class for some Base stats about a character
  attr_accessor :name, :metatype, :age, :sex
  class CharacterBase < OmaiBase
    def initialize(options = { name: '',
                               metatype: '',
                               age: '',
                               sex: '',
                               notes: '' })
      @name = options[:name]
      @metatype = options[:metatype]
      @age = options[:age]
      @sex = options[:sex]
      super
    end
  end
end

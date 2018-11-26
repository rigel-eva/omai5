# frozen_string_literal: true

module Omai5
  class OmaiBase
    attr_accessor :notes
    def initialize(options = { notes: '' })
      @notes = options[:notes]
    end
  end
end

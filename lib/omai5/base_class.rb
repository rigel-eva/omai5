# frozen_string_literal: true

module Omai5
  class OmaiBase
    def initialize(options = { notes: '' })
      @notes = options[:notes]
    end
  end
end

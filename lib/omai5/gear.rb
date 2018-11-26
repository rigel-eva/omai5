module Omai5
  class Gear < Omai5::OmaiBase
    def initialize(id, name, category, rating, quantity, availability, cost,
                   options = { subgear: [],
                               weaponbonus: [],
                               version: nil,
                               notes: '' })
      @id = id
      @name = name
      @category = category
      @rating = rating
      @quantity = quantity
      @availability = availability
      @cost = cost
      @subgear = options[:subgear]
      @version = options[:version]
      super options
    end

    def stringify(level = 0)
      tabs = ''
      (0..level - 1).each do |_i|
        tabs += "\t"
      end
      returner = "#{tabs}#{@name}: #{@quantity}"
      @subgear.each do |gear|
        returner += "\n#{gear.stringify(level + 1)}"
      end
      returner
    end

    def to_s
      stringify
    end
    class << self
      def from_gear_node(node_set, options = { version: nil })
        version = options[:version]
        children = node_set.xpath('.//children/gear').map do |child|
          Omai5::Gear.from_gear_node(child, version: version)
        end
        id = node_set.xpath('.//id/text()')[0][0].to_s
        name = node_set.xpath('.//name/text()')[0].to_s
        catagory = node_set.xpath('.//category/text()')[0].to_s
        rating = node_set.xpath('.//rating/text()')[0].to_s
        quantity = node_set.xpath('.//qty/text()')[0].to_s
        availability = node_set.xpath('.//avail/text()')[0].to_s
        cost = node_set.xpath('.//cost/text()')[0].to_s
        notes = node_set.xpath('.//notes/text()')[0].to_s
        Omai5::Gear.new(id, name, catagory, rating, quantity, availability, cost,
                        subgear: children, note: notes)
      end

      def from_base_node(node_set, options = { version: nil })
        gears = []
        version = options[:version]
        version = node_set.xpath('//appversion/text()').to_s if version.nil?
        node_set.xpath('/character/gears/gear').each do |gear|
          gears.push(from_gear_node(gear, version: version))
        end
        gears
      end
    end
  end
end

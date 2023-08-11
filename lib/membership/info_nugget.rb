module Membership
  class InfoNugget
    @@n = -1

    def initialize(name, pos, callback)
      @callback = callback
      Rails::Info.properties.insert(pos, [name, self])
    end

    def self.new_at_head(name, callback)
      @@n += 1
      new(name, @@n, callback)
    end

    def self.new_at_end(name, callback)
      n = Rails::Info.properties.length
      new(name, n, callback)
    end

    def to_s
      @callback.call.to_s
    rescue Exception
      ""
    end
  end
end

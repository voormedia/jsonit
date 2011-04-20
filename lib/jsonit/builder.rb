module Jsonit
  class Builder
    def initialize
      @document = scoped! do
        yield self if block_given?
      end
    end

    def to_s
      @document.to_json
    end

    def to_json(*)
      to_s
    end

    def set!(key, value=nil, &blk)
      @current_scope[key] = if !block_given?
        value
      elsif value
        array!(key, value, &blk)
      else
        object!(key, &blk)
      end
    end
    alias_method :method_missing, :set!
    
    private

    def scoped!
      @current_scope, previous_scope = {}, @current_scope
      yield
      @current_scope
    ensure
      @current_scope = previous_scope
    end

    def object!(key, &blk)
      scoped!(&blk)
    end

    def array!(key, collection, &blk)
      collection.map do |itm|
        scoped! { blk.call(itm) }
      end
    end
  end
end

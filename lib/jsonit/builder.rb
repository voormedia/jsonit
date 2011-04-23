module Jsonit
  class Builder

    instance_methods.each { |m| undef_method(m) unless m.to_s =~ /^__|object_id|\?$/ }

    def initialize(scope={})
      @document = @current_scope = scope
      yield self if block_given?
    end

    def to_s
      to_json
    end

    def to_json(*args)
      @document.to_json(*args)
    end

    def set!(key=nil, value=nil, &blk)
      if !block_given?
        if value.is_a?(Hash) && @current_scope[key].is_a?(Hash)
          @current_scope[key].merge!(value)
        else
          @current_scope[key] = value
        end
      elsif value.is_a?(Enumerable)
        array!(key, value, &blk)
      else
        object!(key, value, &blk)
      end
      self
    end
    alias_method :method_missing, :set!
    
    def object!(key=nil, value=nil, &blk)
      @current_scope, previous_scope = {}, @current_scope
      yield value
      @current_scope, new_scope = previous_scope, @current_scope
      !key.nil? ? set!(key, new_scope) : Builder.new(new_scope)
    end
    
    def array!(key, collection=[], &blk)
      collection.map! { |itm| object!(nil, itm, &blk) } if block_given?
      set!(key, collection)
    end
  end
end

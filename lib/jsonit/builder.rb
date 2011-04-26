module Jsonit
  class Builder

    instance_methods.each { |m| undef_method(m) unless m.to_s =~ /^__|object_id|\?$|!$/ }

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
        assign!(key, value)
      elsif value.is_a?(Enumerable)
        array!(key, value, &blk)
      else
        object!(key, value, &blk)
      end
      self
    end

    def object!(key=nil, value=nil, &blk)
      @current_scope, previous_scope = {}, @current_scope
      yield value
      @current_scope, new_scope = previous_scope, @current_scope
      !key.nil? ? assign!(key, new_scope) : Builder.new(new_scope)
    end
    
    def array!(key, collection=[], &blk)
      collection.map! { |itm| object!(nil, itm, &blk) } if block_given?
      assign!(key, collection)
    end

    def assign!(key, value=nil)
      if value.is_a?(Hash) && @current_scope[key].is_a?(Hash)
        @current_scope[key].merge!(value)
      else
        @current_scope[key] = value
      end
      self
    end
    
    def method_missing(meth, *args, &blk)
      if (meth.to_s =~ /\?$|!$/).nil?
        return set!(meth, *args, &blk)
      end
      super
    end
  end
end

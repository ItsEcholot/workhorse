module Workhorse
  class ScopedEnv
    def initialize(delegation_object, methods, backup_binding = nil)
      @delegation_object = delegation_object
      @methods = methods
      @backup_binding = backup_binding
    end

    def method_missing(symbol, *args, &block)
      if @methods.include?(symbol)
        @delegation_object.send(symbol, *args, &block)
      elsif @backup_binding&.respond_to?(symbol)
        @backup_binding.send(symbol, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @methods.include?(symbol) || super
    end
  end
end

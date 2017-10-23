module SearchWarrant
  VERSION = "0.1.0"

  HOOK_METHODS = %i(
    search_warrant_before_method_hook
    search_warrant_after_method_succeeds_hook
    search_warrant_after_method_fails_hook
  )

  def self.suppress_tracing
    old_value = Thread.current[:'suppress tracing']
    Thread.current[:'suppress tracing'] = true
    yield
  ensure
    Thread.current[:'suppress tracing'] = old_value
  end

  def self.bypass_trace?(method_name)
    Thread.current[:'suppress tracing'] ||
      SearchWarrant.suppress_tracing { HOOK_METHODS.include?(method_name) }
  end

  def self.before_method_hook(object, method_name, args)
    return if bypass_trace?(method_name)
    SearchWarrant.suppress_tracing { object.search_warrant_before_method_hook(method_name, args) }
  end

  def self.after_method_succeeds_hook(object, method_name, result)
    return if bypass_trace?(method_name)
    SearchWarrant.suppress_tracing { object.search_warrant_after_method_succeeds_hook(method_name, result) }
  end

  def self.after_method_fails_hook(object, method_name, error)
    return if bypass_trace?(method_name)
    SearchWarrant.suppress_tracing { object.search_warrant_after_method_fails_hook(method_name, error) }
  end

  def self.wrap_method(klass, method_name)
    method_hash = klass.const_get(:METHOD_HASH)
    method_hash[method_name] = klass.instance_method(method_name)
    klass.class_eval do
      define_method(method_name) do |*args, &block|
        SearchWarrant.before_method_hook(self, method_name, args)
        begin
          result = method_hash[method_name].bind(self).call(*args, &block)
        rescue => error
          SearchWarrant.after_method_fails_hook(self, method_name, error)
          raise error
        end
        SearchWarrant.after_method_succeeds_hook(self, method_name, result)
        result
      end
    end
  end

  def self.included(klass)
    klass.const_set(:METHOD_HASH, {})

    # For methods defined directly within the class
    def klass.method_added(name)
      return if @_adding_a_method
      SearchWarrant.suppress_tracing do
        @_adding_a_method = true
        SearchWarrant.wrap_method(self, name)
        @_adding_a_method = false
      end
    end

    # For modules mixed in BEFORE SearchWarrant
    # And base classes (excluding Object/BasicObject)
    (klass.instance_methods - Object.instance_methods).each do |method|
      klass.method_added(method)
    end

    # For modules mixed in AFTER SearchWarrant
    def klass.include(module_name)
      super
      (module_name.instance_methods - Object.instance_methods).each do |method|
        method_added(method)
      end
    end
  end

  def search_warrant_before_method_hook(method_name, args)
    Thread.current[:'method trace depth'] ||= 0
    print "#{'  '*Thread.current[:'method trace depth']}==> "
    puts "In #{caller[6]}"
    print '  ' * (Thread.current[:'method trace depth'] + 2)
    puts "Calling #{self.inspect}.#{method_name}(#{args.map(&:inspect).join(', ')})"
    Thread.current[:'method trace depth'] += 1
  end

  def search_warrant_after_method_succeeds_hook(method_name, result)
    Thread.current[:'method trace depth'] -= 1
    puts "#{'  '*Thread.current[:'method trace depth']}<== " +
      "Returns #{result.inspect}"
  end

  def search_warrant_after_method_fails_hook(method_name, error)
    puts "<== FAILS with error: #{error.message}"
  end
end

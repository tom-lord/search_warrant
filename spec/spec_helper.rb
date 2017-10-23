$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'search_warrant'

# Due to the nature of this library, it is desirable NOT
# to use RSpec's built-in output matcher...
def capture_stdout
  original_stdout = $stdout
  $stdout = StringIO.new
  yield
  @buffer = $stdout.string
ensure
  $stdout = original_stdout
end

module ModuleBefore
  def included_method_before
    'method added BEFORE SearchWarrant'
  end
end

module ModuleAfter
  def included_method_after
    'method added AFTER SearchWarrant'
  end
end

class ClassWithSearchWarrant
  include ModuleBefore
  include SearchWarrant
  include ModuleAfter
  attr_reader :ivar
  def initialize(i)
    @ivar = i
  end

  def simple_method(x, y, z)
    x+y+z
  end
  
  def method_with_block
    yield
  end

  def method_that_fails
    raise 'Whoops!'
  end
end

class ClassWithSearchWarrantOverrides
  include SearchWarrant
  def method_that_works
    'Everything is OK'
  end
  def method_that_fails
    raise 'Whoops!'
  end

  def search_warrant_before_method_hook(method_name, args)
    puts "Custom before hook: Calling #{method_name} with #{args.inspect}"
  end

  def search_warrant_after_method_succeeds_hook(result)
    puts "Custom success hook - Result: #{result}"
  end

  def search_warrant_after_method_fails_hook(error)
    puts "Custom failure hook - Error: #{error.message}"
  end
end

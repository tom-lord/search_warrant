require 'spec_helper'

describe SearchWarrant do
  it 'has a version number' do
    expect(SearchWarrant::VERSION).not_to be nil
  end

  it 'traces initialization method' do
    expect { ClassWithTrace.new(1) }
      .to output("==> Calling initialize with [1]\n<== Returns 1\n").to_stdout
  end

  it 'traces instance var read access' do
    # TODO: silence STDOUT here on init
    object_with_trace = ClassWithTrace.new('ivar_value')
    expect { object_with_trace.ivar }
      .to output("==> Calling ivar with []\n<== Returns ivar_value\n").to_stdout
  end

  it 'traces simple instance method call (defined in class)' do
    # TODO: silence STDOUT here on init
    object_with_trace = ClassWithTrace.new('ivar_value')
    expect { object_with_trace.simple_method(1, 2, 3) }
      .to output("==> Calling simple_method with [1, 2, 3]\n<== Returns 6\n")
      .to_stdout
  end

  it 'traces yielding instance method call (defined in class)' do
    # TODO: silence STDOUT here on init
    object_with_trace = ClassWithTrace.new('ivar_value')
    expect { object_with_trace.method_with_block { 123 } }
      .to output("==> Calling method_with_block with []\n<== Returns 123\n")
      .to_stdout
  end
end


# TODO specs:
#begin
#  SearchWarrant.suppress_tracing { a.method_that_fails("DON'T trace") }
#end
#
#begin
#  a.method_that_fails("DO trace")
#end
#
#a.included_method_before
#a.included_method_after
#
#
#b = ClassWithSearchWarrantOverrides.new
#b.method_that_works
#begin
#  b.method_that_fails
#end

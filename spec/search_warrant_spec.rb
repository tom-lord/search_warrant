require 'spec_helper'

describe SearchWarrant do
  it 'has a version number' do
    expect(SearchWarrant::VERSION).not_to be nil
  end

  it 'traces initialization method' do
    output = capture_stdout do
      @object_with_trace = ClassWithSearchWarrant.new(1)
    end
    expect(output).to match(
/==> In #{Regexp.escape(__FILE__)}:\d+:in `new'
    Calling #{Regexp.escape(@object_with_trace.inspect.gsub(' @ivar=1', ''))}.initialize\(1\)
<== Returns 1/
    )
  end

  it 'traces instance var read access' do
    output = capture_stdout do
      @object_with_trace = ClassWithSearchWarrant.new('ivar_value')
      @object_with_trace.ivar
    end
    expect(output).to match(
/==> In #{Regexp.escape(__FILE__)}:\d+:in `block \(3 levels\) in <top \(required\)>'
    Calling #{Regexp.escape(@object_with_trace.inspect)}.ivar\(\)
<== Returns "ivar_value"/
    )
  end

  it 'traces simple instance method call (defined in class)' do
    output = capture_stdout do
      @object_with_trace = ClassWithSearchWarrant.new('ivar_value')
      @object_with_trace.simple_method(1, 2, 3)
    end
    expect(output).to match(
/==> In #{Regexp.escape(__FILE__)}:\d+:in `block \(3 levels\) in <top \(required\)>'
    Calling #{Regexp.escape(@object_with_trace.inspect)}.simple_method\(1, 2, 3\)
<== Returns 6/
    )
  end

  it 'traces yielding instance method call (defined in class)' do
    output = capture_stdout do
      @object_with_trace = ClassWithSearchWarrant.new('ivar_value')
      @object_with_trace.method_with_block { 123 }
    end
    expect(output).to match(
/==> In #{Regexp.escape(__FILE__)}:\d+:in `block \(3 levels\) in <top \(required\)>'
    Calling #{Regexp.escape(@object_with_trace.inspect)}.method_with_block\(\)
<== Returns 123/
    )
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

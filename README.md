# SearchWarrant

A library to trace method calls on **any** given ruby class. Use with caution!

## Danger

This library was written primarily as a fun meta-programming chalenge; it's not intended for use in production!

For one thing, this library could be massively simplified by utilising [Module#prepend](https://ruby-doc.org/core/Module.html#method-i-prepend).
I intentionally used `Module#include` instead, to make the challenge more interesting.

Moreover, core ruby actually provides a built-in means of tracing method calls: [`TracePoint`](https://ruby-doc.org/core/TracePoint.html).
Therefore this functionality could instead be achieved via:

```
Tracepoint.new(:call, :c_call, :return, :c_return) do |trace|
  # ...
end
```

Now with that said, here's how this library works:

## Installation

The usual: 

```ruby
gem install search_warrant
```

## Usage

```ruby
class Foo
  include SearchWarrant # <-- !!!

  def hello(x)
    greeting('hello', x)
  end

  private

  def greeting(intro, message)
    "#{intro}, #{message}".capitalize
  end
end

Foo.new.hello('world')

==> In (irb):14:in `irb_binding'
    Calling #<Foo:0x00000001674250>.hello("world")
  ==> In (irb):4:in `hello'
      Calling #<Foo:0x00000001674250>.greeting("hello", "world")
  <== Returns "Hello, world"
<== Returns "Hello, world"

 => "Hello, world"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tom-lord/search_warrant.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


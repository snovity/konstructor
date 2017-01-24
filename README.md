[![Gem Version](http://img.shields.io/gem/v/konstructor.svg)][gem]
[![Build Status](https://travis-ci.org/snovity/konstructor.svg?branch=master)][travis]
[![Coverage Status](https://coveralls.io/repos/github/snovity/konstructor/badge.svg?branch=master)][coveralls]
[![Dependency Status](https://gemnasium.com/badges/github.com/snovity/konstructor.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/snovity/konstructor/badges/gpa.svg)][codeclimate]

https://codeclimate.com/github/snovity/konstructor/badges/gpa.svg

[gem]: https://rubygems.org/gems/konstructor
[travis]: http://travis-ci.org/snovity/konstructor
[coveralls]: https://coveralls.io/github/snovity/konstructor
[gemnasium]: https://gemnasium.com/snovity/konstructor
[codeclimate]: https://codeclimate.com/github/snovity/konstructor

# Konstructor

This is a small gem that gives you multiple
constructors in Ruby.

Use `konstructor` keyword to declare constructors additional 
to the defaul one:
```ruby
class SomeClass
  konstructor
  def create(val)
    @val = val
  end 
  
  attr_reader :val
end

obj0 = SomeClass.new
obj0.val # nil

obj1 = SomeClass.create(3)
obj1.val # 3
```
It's similar to having overloaded constructors in other languages.

## Installation

Via Gemfile:

```ruby
gem 'konstructor' 
```

and then execute `bundle`. 

You can also install it without Bundler:

    $ gem install konstructor

If you are a gem author or just wish to manually include `konstructor` 
keyword in your classes only when you need it, see 
[Manual include](https://github.com/snovity/konstructor/wiki/Manual-include) page.
   
## Usage

In its simplest form `konstructor` declaration creates a 
constructor from the next method.

```ruby
  konstructor
  def create
  end
 
  konstructor
  def recreate
  end
```
 
When method names are given, it creates constructors from 
those methods without affecting the next method.
 
```ruby
  konstructor :create, :recreate
 
  def not_a_constructor
  end
 
  def create
  end
 
  def recreate
  end
```
 
Declaration with method names can be placed anywhere in 
class definition.
 
```ruby
  def create
  end
  konstructor :create
  
  konstructor
  def recreate
  end
```
 
Several declarations may be used, 
all declarations add up without overwriting each other. 
```ruby     
  def create
  end
   
  konstructor :recreate
  konstructor :create
   
  def recreate
  end
``` 
 
In all above cases `SomeClass` will have the default constructor 
and two additional ones.
 
```ruby
 obj0 = SomeClass.new
 obj1 = SomeClass.create
 obj2 = SomeClass.recreate
```
 
If you decide to remove the default Ruby constructor for some reason,
you can achieve the effect by marking it private with Ruby 
method `private_class_method`:
 
```ruby
 class SomeClass
   private_class_method :new
 end   
```
  
#### Same as default constructor
 
Additional constructors work exactly the same way as the default one.

You can pass blocks to them. 

```ruby
  konstructor
  def create(val)
    @val = yield val
  end
  #...

obj = SomeClass.create(3) { |v| v*3 }
obj.val # 9
```

You can override them in subclasses and call `super`.
```ruby
class SomeClass
  konstructor
  def create(val)
    @val = val
  end
  
  attr_reader :val
end

class SomeSubclass < SomeClass
  def create(val1, val2)
    super(val1 * val2)
  end
end

obj = SomeSubclass.create(2, 3)
obj.val # 6
``` 
Once method is declared as `konstructor` in hierarchy, 
it is always a constructor.

There are certain limitations to what can be declared as `konstructor`, 
see 
[Limitations page](https://github.com/snovity/konstructor/wiki/Limitations)
for details.

#### Using with other gems

Konstructor doesn't affect other gems depending on metaprogramming, 
such as 
[rake](https://github.com/ruby/rake),
[thor](https://github.com/erikhuda/thor), 
[contracts](https://github.com/egonSchiele/contracts.ruby), etc.

For instnace, this is how Konstructor works with contracts:
```ruby
class SomeClass
  konstructor
  Contract Num => SomeClass
  def create(some_number)
    @number = some_number
  end
end    

obj0 = SomeClass.create(3)
obj1 = SomeClass.create("three") # raises contract exception
```
  
If you stumble upon a metaprogramming gem that 
conflicts with Konstructor, please 
[open an issue](https://github.com/snovity/konstructor/issues/new).
  
## Details

The default Ruby constructor is a pair consisting of public
class method `new` and a private instance 
method `initialize`. To create an additional constructor `konstructor`
marks instance method as private and defines a corresponding public 
class method with the same name.

#### Performance
 
Using `konstructor` declaration has no runtime perfomance penalty. 
It does all its work when class is being defined, and then it's just 
standard Ruby instance creation. 

Cost of `konstructor` declaration at initial load time is roughly the 
same as declaring 3 properties with `attr_accessor`.
```ruby
  attr_accessor :one, :two, :three
  
  # following declaration takes the same time as above declaration
  konstructor
  def create
  end
```  
See [Benchmarks page](https://github.com/snovity/konstructor/wiki/Benchmarks)
for details.

#### Dependencies and requirements

Konstructor doesn't depend on other gems. 
Requires Ruby `2.0.0` or higher. 
  
#### Thread safety
  
Konstructor is thread safe.

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/snovity/konstructor. This project is intended to be
a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) 
code of conduct.

## License

The gem is available as open source under the terms of the 
[MIT License](http://opensource.org/licenses/MIT).

